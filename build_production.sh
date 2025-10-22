#!/bin/bash

# Campus Téranga Flutter App - Production Build Script
# This script builds the Flutter app for production deployment

echo "🚀 Building Campus Téranga Flutter App for Production..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check Flutter version
print_status "Checking Flutter version..."
flutter --version

# Navigate to app directory
cd "$(dirname "$0")"

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting dependencies..."
flutter pub get

# Check for any issues
print_status "Running Flutter doctor..."
flutter doctor

# Verify configuration
print_status "Verifying production configuration..."
if grep -q "environment = 'production'" lib/config/app_config.dart; then
    print_success "Production environment configured"
else
    print_warning "Production environment not configured, updating..."
    sed -i.bak "s/environment = 'development'/environment = 'production'/g" lib/config/app_config.dart
    print_success "Updated to production environment"
fi

# Build for different platforms
echo ""
print_status "Building for different platforms..."

# Build Android APK
print_status "Building Android APK..."
if flutter build apk --release; then
    print_success "Android APK built successfully"
    print_status "APK location: build/app/outputs/flutter-apk/app-release.apk"
else
    print_error "Failed to build Android APK"
fi

# Build Android App Bundle (for Play Store)
print_status "Building Android App Bundle..."
if flutter build appbundle --release; then
    print_success "Android App Bundle built successfully"
    print_status "AAB location: build/app/outputs/bundle/release/app-release.aab"
else
    print_error "Failed to build Android App Bundle"
fi

# Build for Web
print_status "Building for Web..."
if flutter build web --release; then
    print_success "Web build completed successfully"
    print_status "Web files location: build/web/"
else
    print_error "Failed to build for Web"
fi

# Build for iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Building for iOS..."
    if flutter build ios --release; then
        print_success "iOS build completed successfully"
        print_status "iOS files location: build/ios/iphoneos/"
    else
        print_error "Failed to build for iOS"
    fi
else
    print_warning "Skipping iOS build (not on macOS)"
fi

# Display build summary
echo ""
print_success "🎉 Production build completed!"
echo ""
print_status "Build Summary:"
echo "📱 Android APK: build/app/outputs/flutter-apk/app-release.apk"
echo "📦 Android AAB: build/app/outputs/bundle/release/app-release.aab"
echo "🌐 Web Files: build/web/"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 iOS Files: build/ios/iphoneos/"
fi

echo ""
print_status "Next Steps:"
echo "1. Test the production builds thoroughly"
echo "2. Upload Android AAB to Google Play Console"
echo "3. Deploy web files to your hosting service"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "4. Archive iOS app in Xcode for App Store"
fi
echo "5. Verify API connectivity with production backend"

echo ""
print_success "Campus Téranga Flutter App is ready for production deployment! 🚀"
