#!/bin/bash

set -e

APP_NAME=$(grep "^name:" pubspec.yaml | sed 's/name: //')
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')

echo "Building $APP_NAME v$VERSION (Release Mode)"
rm -rf .dart_tool android/.gradle
flutter clean
flutter gen-l10n
flutter pub run flutter_launcher_icons

echo "Building APK..."
flutter build apk --release \
    --obfuscate \
    --split-debug-info=debug-info/android \
    --suppress-analytics \
    --no-tree-shake-icons

echo "Renaming APK for release..."
mv build/app/outputs/flutter-apk/app-release.apk "build/app/outputs/flutter-apk/$APP_NAME-$VERSION.apk"
echo "Release APK created: $APP_NAME-$VERSION.apk"

echo "Building App Bundle..."
flutter build appbundle --release \
    --obfuscate \
    --split-debug-info=debug-info/android \
    --suppress-analytics \
    --no-tree-shake-icons

echo "Renaming AAB for release..."
mv build/app/outputs/bundle/release/app-release.aab "build/app/outputs/bundle/release/$APP_NAME-$VERSION.aab"
echo "Release AAB created: $APP_NAME-$VERSION.aab"
