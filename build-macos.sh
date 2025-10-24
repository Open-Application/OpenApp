#!/bin/bash

set -e

APP_NAME=$(grep "^name:" pubspec.yaml | sed 's/name: //')
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')

echo "Building $APP_NAME v$VERSION (Release Mode)"
rm -rf .dart_tool macos/.gradle
flutter gen-l10n
flutter pub run flutter_launcher_icons

echo ""
echo "=========================================="
echo "Building DMG for direct distribution..."
echo "=========================================="
flutter build macos --release \
    --obfuscate \
    --split-debug-info=debug-info/macos \
    --suppress-analytics \
    --no-tree-shake-icons

APP_PATH="build/macos/Build/Products/Release/OpenApp.app"
DMG_PATH="build/macos/$APP_NAME-$VERSION.dmg"

DMG_TEMP="build/macos/dmg_temp"
rm -rf "${DMG_TEMP}"
mkdir -p "${DMG_TEMP}"

cp -R "${APP_PATH}" "${DMG_TEMP}/"
ln -s /Applications "${DMG_TEMP}/Applications"

rm -f "${DMG_PATH}"
hdiutil create -volname "$APP_NAME $VERSION" \
    -srcfolder "${DMG_TEMP}" \
    -ov \
    -format UDZO \
    "${DMG_PATH}"

rm -rf "${DMG_TEMP}"

echo "✓ Release DMG created: $APP_NAME-$VERSION.dmg"

echo ""
echo "=========================================="
echo "Building for App Store Connect..."
echo "=========================================="
echo "Using manual signing with provisioning profiles configured in Xcode"
echo ""

flutter clean
flutter build macos --release \
    --obfuscate \
    --split-debug-info=debug-info/macos \
    --suppress-analytics \
    --no-tree-shake-icons

APP_PATH="build/macos/Build/Products/Release/OpenApp.app"
PKG_PATH="build/macos/$APP_NAME-$VERSION.pkg"

echo ""
echo "Verifying code signature..."
echo "Main app signature:"
codesign -dvv "${APP_PATH}" 2>&1 | grep -E "Authority=|TeamIdentifier=|Identifier="

EXTENSION_PATH="${APP_PATH}/Contents/PlugIns/RccExtension.appex"
if [ -d "$EXTENSION_PATH" ]; then
    echo ""
    echo "Extension signature:"
    codesign -dvv "${EXTENSION_PATH}" 2>&1 | grep -E "Authority=|Identifier="
fi

echo ""
echo "Performing deep signature verification..."
SIGNATURE_CHECK=$(codesign --verify --deep --strict --verbose=2 "${APP_PATH}" 2>&1)
if [ $? -eq 0 ]; then
    echo "✓ App and all components are properly signed"
else
    echo "✗ Signature verification failed:"
    echo "$SIGNATURE_CHECK"
    echo ""
    echo "This may indicate an issue with provisioning profiles or code signing."
    echo "Please check Xcode signing settings."
    exit 1
fi

echo ""
echo "Checking for installer certificate..."
INSTALLER_CERT=$(security find-identity -v -p basic | grep "3rd Party Mac Developer Installer" | head -1 | awk -F'"' '{print $2}')

if [ -z "$INSTALLER_CERT" ]; then
    echo ""
    echo "=============================================="
    echo "ERROR: Missing '3rd Party Mac Developer Installer' certificate"
    echo "=============================================="
    echo ""
    echo "For Mac App Store submission, you must sign the PKG with this certificate."
    echo ""
    echo "To fix this:"
    echo "1. Go to https://developer.apple.com/account/resources/certificates/list"
    echo "2. Click '+' to create a new certificate"
    echo "3. Select 'Mac Installer Distribution'"
    echo "4. Follow the prompts to create and download the certificate"
    echo "5. Double-click the downloaded .cer file to install it in Keychain"
    echo "6. Run this build script again"
    echo ""
    echo "Current installed certificates:"
    security find-identity -v -p basic
    echo ""
    exit 1
fi

echo "✓ Found installer certificate: $INSTALLER_CERT"
echo ""
echo "Creating signed .pkg..."
productbuild --component "${APP_PATH}" /Applications --sign "$INSTALLER_CERT" "${PKG_PATH}"

if [ $? -ne 0 ]; then
    echo ""
    echo "✗ Failed to create signed PKG"
    exit 1
fi

echo ""
echo "Verifying PKG signature..."
PKG_SIG_CHECK=$(pkgutil --check-signature "${PKG_PATH}")
echo "$PKG_SIG_CHECK"

if echo "$PKG_SIG_CHECK" | grep -q "Status: signed"; then
    echo "✓ PKG is properly signed"
else
    echo "✗ PKG signature verification failed"
    exit 1
fi

echo ""
echo "✓ App Store package created: $APP_NAME-$VERSION.pkg"

echo ""
echo "=========================================="
echo "Build Complete!"
echo "=========================================="
echo "DMG (Direct distribution): build/macos/$APP_NAME-$VERSION.dmg"
echo "PKG (App Store):          build/macos/$APP_NAME-$VERSION.pkg"
echo ""
echo "To upload to App Store Connect:"
echo "1. Open Transporter app"
echo "2. Upload: build/macos/$APP_NAME-$VERSION.pkg"
echo ""
echo "Or use command line:"
echo "xcrun altool --upload-app --type macos --file build/macos/$APP_NAME-$VERSION.pkg --username YOUR_APPLE_ID --password YOUR_APP_SPECIFIC_PASSWORD"
