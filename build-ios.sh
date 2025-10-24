#!/bin/bash

set -e

APP_NAME=$(grep "^name:" pubspec.yaml | sed 's/name: //')
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')

echo "Building $APP_NAME v$VERSION (Release Mode)"
rm -rf .dart_tool build/ios ios/.Pods
flutter gen-l10n
flutter pub run flutter_launcher_icons
flutter build ipa --release \
    --obfuscate \
    --split-debug-info=debug-info/ios \
    --suppress-analytics \
    --no-tree-shake-icons \
    --export-options-plist=ios/ExportOptions.plist

echo "Renaming IPA for release..."
mv "build/ios/ipa/${APP_NAME}.ipa" "build/ios/ipa/$APP_NAME-$VERSION.ipa"
echo "Release IPA created: $APP_NAME-$VERSION.ipa"