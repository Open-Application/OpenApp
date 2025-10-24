#!/bin/bash

set -e

APP_NAME=$(grep "^name:" pubspec.yaml | sed 's/name: //')
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')

echo "=========================================="
echo "Building $APP_NAME v$VERSION for App Store"
echo "=========================================="
echo ""

rm -rf .dart_tool ios/.gradle
flutter gen-l10n
flutter pub run flutter_launcher_icons

echo ""
echo "Building IPA with Xcode manual signing..."
flutter build ipa --release \
    --obfuscate \
    --split-debug-info=debug-info/ios \
    --suppress-analytics \
    --no-tree-shake-icons

IPA_PATH="build/ios/ipa/${APP_NAME}.ipa"
APP_PATH="build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app"

if [ -d "$APP_PATH" ]; then
    echo ""
    echo "Verifying code signature..."
    codesign -dvv "$APP_PATH" 2>&1 | grep -E "Authority=|TeamIdentifier=|Identifier="

    SIGNATURE_CHECK=$(codesign --verify --deep --strict --verbose=2 "$APP_PATH" 2>&1)
    if [ $? -eq 0 ]; then
        echo "✓ App is properly signed"
    else
        echo "⚠ Signature verification warnings:"
        echo "$SIGNATURE_CHECK"
    fi

    EXTENSION_PATH="$APP_PATH/PlugIns"
    if [ -d "$EXTENSION_PATH" ]; then
        echo ""
        echo "Checking extension signatures..."
        find "$EXTENSION_PATH" -name "*.appex" -print0 | while IFS= read -r -d '' ext; do
            EXT_NAME=$(basename "$ext")
            echo "  - $EXT_NAME"
            codesign -dvv "$ext" 2>&1 | grep -E "Authority=|Identifier=" | sed 's/^/    /'
        done
    fi
fi

echo ""
echo "=========================================="
echo "Build Complete!"
echo "=========================================="
echo "IPA location: $IPA_PATH"
echo ""
echo "To upload to App Store Connect:"
echo ""
echo "Option 1 - Transporter App (Recommended):"
echo "  1. Open Apple's Transporter app"
echo "  2. Drag and drop: $IPA_PATH"
echo "  3. Click 'Deliver'"
echo ""
echo "Option 2 - Command Line:"
echo "  Validate: xcrun altool --validate-app -f \"$IPA_PATH\" -t ios -u YOUR_APPLE_ID -p APP_SPECIFIC_PASSWORD"
echo "  Upload:   xcrun altool --upload-app -f \"$IPA_PATH\" -t ios -u YOUR_APPLE_ID -p APP_SPECIFIC_PASSWORD"
echo ""
echo "Option 3 - Xcode Organizer:"
echo "  1. Open Xcode > Window > Organizer"
echo "  2. Select your archive > Distribute App"
echo ""
echo "Note: You can generate an app-specific password at https://appleid.apple.com"
echo ""
