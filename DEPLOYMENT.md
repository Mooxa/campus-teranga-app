# Campus Téranga Flutter App - Production Deployment Guide

## 🚀 Production Configuration

The Campus Téranga Flutter app is now configured for production deployment with the backend API at `https://campus-teranga-backend.onrender.com/api`.

### 📋 Pre-Deployment Checklist

- [x] **API Configuration**: Updated to use production backend API
- [x] **Environment Configuration**: Production environment settings
- [x] **Error Handling**: Improved network error handling with timeouts
- [x] **Security Headers**: Added proper HTTP headers and User-Agent
- [x] **Build Configuration**: Production-ready build settings

## 🔧 Configuration Files

### 1. API Configuration (`lib/config/app_config.dart`)
```dart
// Production API URL
static const String productionApiUrl = 'https://campus-teranga-backend.onrender.com/api';

// Current environment - set to 'production' for production builds
static const String environment = 'production';
```

### 2. Build Configuration (`lib/config/build_config.dart`)
- Production environment detection
- Platform-specific configurations
- Feature flags for production builds
- Performance and security settings

### 3. API Service (`lib/services/api_service.dart`)
- Updated to use production API URL
- Added timeout configuration (30 seconds)
- Improved error handling for network issues
- Added proper HTTP headers

## 📱 Platform-Specific Deployment

### Android Deployment

1. **Update build configuration:**
   ```bash
   cd campus_teranga_app
   flutter build apk --release
   # or for app bundle (recommended for Play Store)
   flutter build appbundle --release
   ```

2. **Configure signing:**
   - Create keystore for app signing
   - Update `android/app/build.gradle` with signing configuration
   - Set up Play Store deployment

3. **Environment variables:**
   - Ensure `AppConfig.environment = 'production'`
   - Verify API URL is set to production endpoint

### iOS Deployment

1. **Update build configuration:**
   ```bash
   flutter build ios --release
   ```

2. **Configure provisioning:**
   - Set up Apple Developer account
   - Configure provisioning profiles
   - Update `ios/Runner.xcodeproj` settings

3. **App Store deployment:**
   - Archive the app in Xcode
   - Upload to App Store Connect
   - Submit for review

### Web Deployment

1. **Build for web:**
   ```bash
   flutter build web --release
   ```

2. **Deploy to hosting service:**
   - Upload `build/web` folder to your hosting service
   - Configure HTTPS and proper headers
   - Set up custom domain if needed

## 🔐 Security Configuration

### Production Security Settings
- ✅ **HTTPS Only**: All API calls use HTTPS
- ✅ **Certificate Pinning**: Enabled for production builds
- ✅ **Secure Headers**: Proper Content-Type and Accept headers
- ✅ **User-Agent**: Identifies app version for debugging
- ✅ **Timeout Protection**: 30-second timeout for all requests

### Network Security
- ✅ **API Timeout**: 30 seconds maximum
- ✅ **Error Handling**: Graceful handling of network errors
- ✅ **Retry Logic**: Built-in retry mechanism for failed requests
- ✅ **Connection Validation**: Checks for network connectivity

## 🚀 Deployment Steps

### 1. Pre-Deployment Setup
```bash
# Navigate to Flutter app directory
cd campus_teranga_app

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Verify configuration
flutter doctor
```

### 2. Production Build
```bash
# For Android
flutter build apk --release
# or
flutter build appbundle --release

# For iOS
flutter build ios --release

# For Web
flutter build web --release
```

### 3. Testing Production Build
```bash
# Test the release build locally
flutter run --release

# Verify API connectivity
# Test login functionality
# Test all major features
```

## 📊 Monitoring and Analytics

### Production Monitoring
- **Error Tracking**: Configured for production builds
- **Performance Monitoring**: Enabled for production
- **Analytics**: User behavior tracking enabled
- **Crash Reporting**: Automatic crash reporting

### API Monitoring
- **Health Checks**: Backend health monitoring
- **Response Times**: API performance tracking
- **Error Rates**: Failed request monitoring
- **Usage Analytics**: API usage statistics

## 🔄 Environment Management

### Switching Environments
To switch between development and production:

1. **Development Mode:**
   ```dart
   // In lib/config/app_config.dart
   static const String environment = 'development';
   ```

2. **Production Mode:**
   ```dart
   // In lib/config/app_config.dart
   static const String environment = 'production';
   ```

### Environment Variables
The app automatically detects the environment and configures:
- API endpoints
- Logging levels
- Feature flags
- Security settings
- Performance monitoring

## 📱 App Store Deployment

### Google Play Store (Android)
1. Create signed APK/AAB
2. Upload to Google Play Console
3. Fill out store listing information
4. Submit for review

### Apple App Store (iOS)
1. Archive app in Xcode
2. Upload to App Store Connect
3. Configure app information
4. Submit for review

## 🌐 Web Deployment

### Hosting Options
- **Vercel**: Recommended for Next.js-like deployment
- **Netlify**: Static site hosting
- **Firebase Hosting**: Google's hosting solution
- **AWS S3 + CloudFront**: Scalable hosting

### Web Configuration
```bash
# Build for web
flutter build web --release

# Deploy to hosting service
# Upload build/web folder contents
```

## 🐛 Troubleshooting

### Common Issues

1. **API Connection Errors:**
   - Verify backend is running at production URL
   - Check network connectivity
   - Verify CORS configuration

2. **Build Errors:**
   - Run `flutter clean` and rebuild
   - Check Flutter and Dart versions
   - Verify all dependencies are compatible

3. **Authentication Issues:**
   - Verify JWT secret configuration
   - Check token expiration settings
   - Test login flow thoroughly

### Debug Mode
To enable debug mode for troubleshooting:
```dart
// In lib/config/app_config.dart
static const String environment = 'development';
```

## 📞 Support

For deployment issues or questions:
- Check the backend API health: `https://campus-teranga-backend.onrender.com/health`
- Verify API endpoints are accessible
- Test authentication flow
- Check network connectivity

## 🎉 Production Features

The production app includes:
- ✅ **Full API Integration** with production backend
- ✅ **User Authentication** with secure JWT tokens
- ✅ **Formations Management** for educational programs
- ✅ **Events System** for student activities
- ✅ **Services Directory** for student services
- ✅ **Admin Dashboard** for content management
- ✅ **Offline Support** with local caching
- ✅ **Push Notifications** for important updates
- ✅ **Analytics Integration** for usage tracking
- ✅ **Error Reporting** for issue monitoring

Your Campus Téranga Flutter app is now ready for production deployment! 🚀
