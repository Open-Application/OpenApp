#!/bin/bash

set -e

VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')

DEBUG_MODE=false
TEST_MODE=false
RELEASE_MODE=false

if [ "$1" = "-d" ]; then
    DEBUG_MODE=true
elif [ "$1" = "-t" ]; then
    TEST_MODE=true
elif [ "$1" = "-r" ]; then
    RELEASE_MODE=true
elif [ -n "$1" ]; then
    echo "Invalid option: $1" >&2
    echo "Usage: $0 [-d] [-t] [-r]"
    echo "  -d  Debug mode (skip clean and build)"
    echo "  -t  Test mode (skip landing and auth)"
    echo "  -r  Release mode (create MSIX package)"
    exit 1
fi

if [ "$TEST_MODE" = true ]; then
    echo "Test mode: Modifying files for debug..."

    cp lib/router.dart lib/router.dart.backup
    cp lib/pages/dashboard.dart lib/pages/dashboard.dart.backup

    sed -i '' "s|initialLocation: '/',|initialLocation: '/dashboard',|g" lib/router.dart
    sed -i '' "s|final bool isAuthenticated = user.isAuthenticated ?? false;|final bool isAuthenticated = true;|g" lib/pages/dashboard.dart
fi

if [ "$DEBUG_MODE" = false ]; then
    echo "Building OpenApp v$VERSION for Windows"
    rm -rf .dart_tool windows/.gradle
    flutter gen-l10n
    flutter pub run flutter_launcher_icons
    flutter build windows --release --obfuscate --split-debug-info=debug-info --suppress-analytics --no-tree-shake-icons
fi

if [ "$TEST_MODE" = true ]; then
    echo "Test mode: Restoring original files..."
    mv lib/router.dart.backup lib/router.dart
    mv lib/pages/dashboard.dart.backup lib/pages/dashboard.dart
    echo "Files restored"
fi

if [ "$RELEASE_MODE" = true ]; then
    echo "========================================="
    echo "Windows Release Build"
    echo "========================================="
    echo ""
    echo "Version: ${VERSION}"
    echo ""

    # Check if running on Windows (via Git Bash, WSL, or Cygwin)
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        echo "Step 1: Creating MSIX package..."

        # Build MSIX package
        flutter pub run msix:create --version "$VERSION" --build-windows false

        if [ -f "build/windows/runner/Release/openapp.msix" ]; then
            echo ""
            echo "Step 2: Renaming MSIX for release..."
            mv "build/windows/runner/Release/openapp.msix" "build/windows/runner/Release/OpenApp-$VERSION.msix"
            echo "Release MSIX created: OpenApp-$VERSION.msix"

            MSIX_SIZE=$(du -h "build/windows/runner/Release/OpenApp-$VERSION.msix" | cut -f1)
            echo "  Size: ${MSIX_SIZE}"
            echo ""
            echo "========================================="
            echo "Build Complete!"
            echo "========================================="
            echo ""
            echo "Build Artifacts:"
            echo "  MSIX Package: build/windows/runner/Release/OpenApp-$VERSION.msix"
            echo ""
            echo "Next steps:"
            echo "1. Test the MSIX package on Windows"
            echo "2. Sign the package for distribution"
            echo "3. Distribute via Microsoft Store or sideloading"
        else
            echo ""
            echo "⚠️  MSIX package not found at expected location"
            echo "Checking for alternative locations..."
            find build/windows -name "*.msix" -type f 2>/dev/null || echo "No MSIX files found"

            echo ""
            echo "Creating portable build instead..."
            mkdir -p "build/windows/release/OpenApp-$VERSION"
            cp -r build/windows/runner/Release/* "build/windows/release/OpenApp-$VERSION/"

            echo ""
            echo "Portable build created: build/windows/release/OpenApp-$VERSION/"
            echo ""
            echo "To create an installer, consider using:"
            echo "  - Inno Setup (https://jrsoftware.org/isinfo.php)"
            echo "  - WiX Toolset (https://wixtoolset.org/)"
            echo "  - Advanced Installer (https://www.advancedinstaller.com/)"
        fi
    else
        echo "⚠️  Not running on Windows. Creating portable build..."
        echo ""
        echo "Note: MSIX packages can only be created on Windows"
        echo "Creating a portable Windows build instead..."
        echo ""

        mkdir -p "build/windows/release/OpenApp-$VERSION"
        if [ -d "build/windows/runner/Release" ]; then
            cp -r build/windows/runner/Release/* "build/windows/release/OpenApp-$VERSION/"

            echo "Portable build created: build/windows/release/OpenApp-$VERSION/"
            echo ""
            echo "Contents:"
            ls -lh "build/windows/release/OpenApp-$VERSION/"
            echo ""
            echo "To create an MSIX package:"
            echo "1. Run this script on a Windows machine"
            echo "2. Or manually create MSIX using: flutter pub run msix:create"
        else
            echo "❌ Windows build directory not found!"
            echo "Make sure you have run the Windows build first."
            exit 1
        fi
    fi
else
    # Development build
    echo ""
    echo "Build complete!"
    echo ""

    if [ -d "build/windows/runner/Release" ]; then
        echo "Windows build: build/windows/runner/Release/"
        echo ""

        # Check if running on Windows
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
            echo "To run the app:"
            echo "  ./build/windows/runner/Release/openapp.exe"
            echo ""
            echo "Or run directly from Explorer:"
            echo "  start build/windows/runner/Release/openapp.exe"
        else
            echo "Transfer the build/windows/runner/Release/ directory to a Windows machine to run."
        fi

        echo ""
        echo "To create a release build with MSIX package:"
        echo "  ./build-windows.sh -r"
    else
        echo "❌ Windows build directory not found!"
        echo "Make sure the build completed successfully."

        echo ""
        echo "Checking for build artifacts..."
        find build/windows -name "*.exe" -type f 2>/dev/null || echo "No executables found"
    fi
fi
