#!/bin/bash

set -e

APP_NAME=$(grep "^name:" pubspec.yaml | sed 's/name: //')
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')

echo "Building $APP_NAME v$VERSION (Release Mode)"

# Clean Flutter cache and build directories
cd ~/OpenApp
rm -rf .dart_tool build/
flutter clean

# Clean OpenCore build artifacts
cd ~/OpenCore/export
rm -f liboc.dll liboc.h liboc.def
cd ~/OpenCore
go clean -cache 2>/dev/null || true

# Build liboc.dll
echo "Building liboc.dll..."
cd ~/OpenCore/export

# Set environment variables
export CC="x86_64-w64-mingw32-gcc"
export CXX="x86_64-w64-mingw32-g++"
export PATH="/c/Program Files/Go/bin:/c/Program Files/llvm-mingw-20240619-ucrt-x86_64/bin:$PATH"

# Build configuration
TAGS="with_gvisor,with_quic,with_wireguard,with_utls,with_low_memory,with_conntrack,with_clash_api"
BUILD_VERSION="v0.0.3-embedded-wintun"
LDFLAGS="-X github.com/sagernet/sing-box/constant.Version=$BUILD_VERSION -s -w -buildid= -checklinkname=0"

# Build the DLL
CGO_ENABLED=1 GOOS=windows GOARCH=amd64 go build -v \
    -buildmode=c-shared \
    -tags="$TAGS,netcgo" \
    -trimpath \
    -ldflags="$LDFLAGS" \
    -o liboc.dll \
    ./ffi.go

# Copy files to OpenApp and generate import library
cp liboc.dll ~/OpenApp/windows/
cp liboc.h ~/OpenApp/windows/

# Generate import library
cd ~/OpenApp/windows
gendef liboc.dll
dlltool -d liboc.def -D liboc.dll -l liboc.lib

# Clear debug log
rm -f ~/AppData/Roaming/io.root-corporation/openapp/debug.log
mkdir -p ~/AppData/Roaming/io.root-corporation/openapp
touch ~/AppData/Roaming/io.root-corporation/openapp/debug.log

# Build Windows application
cd ~/OpenApp
echo "Building Windows MSIX..."
flutter build windows --release \
    --obfuscate \
    --split-debug-info=debug-info/windows \
    --suppress-analytics \
    --no-tree-shake-icons

echo "Renaming MSIX for release..."
mv build/windows/x64/runner/Release "$APP_NAME-$VERSION-windows"
echo "Release Windows build created: $APP_NAME-$VERSION-windows"