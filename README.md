# Campus Téranga Flutter App

**Votre guide complet pour réussir vos études au Sénégal**

## 📱 About

Campus Téranga is a comprehensive Flutter mobile application designed to help students succeed in their educational journey in Senegal. The app provides access to educational formations, events, services, and a supportive community.

## 🚀 Production Ready

This app is configured for production deployment with the backend API at `https://campus-teranga-backend.onrender.com/api`.

### Key Features

- ✅ **User Authentication** - Secure login and registration
- ✅ **Formations Management** - Browse and search educational programs
- ✅ **Events System** - Discover and register for student events
- ✅ **Services Directory** - Access to student services (transport, housing, etc.)
- ✅ **Admin Dashboard** - Content management for administrators
- ✅ **Offline Support** - Local caching for better performance
- ✅ **Push Notifications** - Stay updated with important announcements
- ✅ **Multi-language Support** - French and English interface

## 🛠️ Technical Stack

- **Framework**: Flutter 3.6.1+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: SharedPreferences
- **UI Components**: Material Design with custom theming
- **Backend API**: Node.js/Express.js (Deployed on Render)

## 📦 Installation

### Prerequisites

- Flutter SDK 3.6.1 or higher
- Dart SDK 3.6.1 or higher
- Android Studio / Xcode (for mobile development)
- VS Code (recommended IDE)

### Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd campus_teranga_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify installation:**
   ```bash
   flutter doctor
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🏗️ Build Configuration

### Development Mode
```dart
// In lib/config/app_config.dart
static const String environment = 'development';
```

### Production Mode
```dart
// In lib/config/app_config.dart
static const String environment = 'production';
```

## 🚀 Production Deployment

### Quick Build Script
```bash
# Make script executable
chmod +x build_production.sh

# Run production build
./build_production.sh
```

### Manual Build Commands

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle (Play Store):**
```bash
flutter build appbundle --release
```

**Web:**
```bash
flutter build web --release
```

**iOS (macOS only):**
```bash
flutter build ios --release
```

## 📱 Platform Support

- ✅ **Android** 5.0+ (API level 21+)
- ✅ **iOS** 11.0+
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Windows** 10+
- ✅ **macOS** 10.14+
- ✅ **Linux** (Ubuntu, Debian, etc.)

## 🔧 Configuration

### API Configuration
The app automatically configures the API endpoint based on the environment:

- **Production**: `https://campus-teranga-backend.onrender.com/api`
- **Development**: `http://127.0.0.1:3000/api`

### Environment Variables
Key configuration settings in `lib/config/app_config.dart`:

- `environment`: Set to 'production' for production builds
- `apiTimeoutSeconds`: Request timeout (default: 30 seconds)
- `enableLogging`: Enable/disable logging
- `enableAnalytics`: Enable/disable analytics

## 📊 Features Overview

### User Features
- **Registration/Login**: Secure user authentication
- **Profile Management**: Update personal information
- **Formations Browse**: Search and filter educational programs
- **Event Registration**: Join student events and activities
- **Services Access**: Find transport, housing, and other services
- **Notifications**: Receive important updates

### Admin Features
- **Dashboard**: Overview of app statistics
- **User Management**: Manage user accounts and roles
- **Content Management**: Add/edit formations, events, and services
- **Analytics**: View usage statistics and insights

## 🔐 Security

- **HTTPS Only**: All API communications use HTTPS
- **JWT Authentication**: Secure token-based authentication
- **Certificate Pinning**: Enhanced security for production builds
- **Input Validation**: Client-side and server-side validation
- **Error Handling**: Graceful error handling and user feedback

## 📈 Performance

- **Optimized Images**: Efficient image loading and caching
- **Lazy Loading**: Content loaded on demand
- **Offline Support**: Local caching for better performance
- **Network Optimization**: Request timeouts and retry logic
- **Memory Management**: Efficient memory usage patterns

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Test Coverage
```bash
flutter test --coverage
```

## 📚 API Documentation

The app integrates with the Campus Téranga backend API. Key endpoints:

- **Authentication**: `/api/auth/login`, `/api/auth/register`
- **Formations**: `/api/formations`
- **Events**: `/api/events`
- **Services**: `/api/services`
- **Admin**: `/api/admin/*`

## 🐛 Troubleshooting

### Common Issues

1. **Build Errors:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **API Connection Issues:**
   - Verify backend is running
   - Check network connectivity
   - Verify API URL configuration

3. **Dependencies Issues:**
   ```bash
   flutter pub deps
   flutter pub upgrade
   ```

## 📞 Support

For support and questions:
- **Backend API**: https://campus-teranga-backend.onrender.com
- **Health Check**: https://campus-teranga-backend.onrender.com/health
- **Documentation**: See DEPLOYMENT.md for detailed deployment guide

## 📄 License

This project is licensed under the ISC License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🎯 Roadmap

- [ ] **Push Notifications**: Real-time notifications
- [ ] **Offline Mode**: Enhanced offline functionality
- [ ] **Multi-language**: Full internationalization
- [ ] **Dark Mode**: Theme customization
- [ ] **Social Features**: Community interactions
- [ ] **Payment Integration**: In-app payments
- [ ] **Advanced Analytics**: Detailed usage insights

---

**Campus Téranga** - Your guide to success in Senegal! 🇸🇳

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
