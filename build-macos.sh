#!/bin/bash

set -e

APP_NAME=$(grep "^name:" pubspec.yaml | sed 's/name: //')
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')

echo "Building $APP_NAME v$VERSION (Release Mode)"
rm -rf .dart_tool build/macos macos/.Pods
flutter clean
flutter gen-l10n
flutter pub run flutter_launcher_icons

flutter build macos --release \
    --obfuscate \
    --split-debug-info=debug-info/macos \
    --suppress-analytics \
    --no-tree-shake-icons

APP_PATH="build/macos/Build/Products/Release/OpenApp.app"
PKG_PATH="build/macos/$APP_NAME-$VERSION.pkg"

echo "Creating PKG for App Store..."
INSTALLER_CERT=$(security find-identity -v -p basic | grep "3rd Party Mac Developer Installer" | head -1 | awk -F'"' '{print $2}')
productbuild --component "${APP_PATH}" /Applications --sign "$INSTALLER_CERT" "${PKG_PATH}"
echo "Release PKG created: $APP_NAME-$VERSION.pkg"
