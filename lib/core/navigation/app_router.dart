import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/admin/presentation/pages/admin_login_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/formations/presentation/pages/formations_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/events/presentation/pages/events_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// App Router Configuration using GoRouter
/// 
/// This router provides:
/// - Declarative routing
/// - Authentication guards
/// - Route transitions
/// - Deep linking support
/// - Navigation state management
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    
    // Redirect logic based on authentication state
    redirect: (context, state) {
      final isAuthenticated = authState;
      final isOnboardingCompleted = true; // This would come from storage
      
      // If not authenticated and not on auth pages, redirect to login
      if (!isAuthenticated && 
          !state.matchedLocation.startsWith('/auth') &&
          state.matchedLocation != '/splash' &&
          state.matchedLocation != '/onboarding') {
        return '/auth/login';
      }
      
      // If authenticated and on auth pages, redirect to home
      if (isAuthenticated && state.matchedLocation.startsWith('/auth')) {
        return '/home';
      }
      
      // If not onboarded and not on onboarding, redirect to onboarding
      if (!isOnboardingCompleted && 
          state.matchedLocation != '/onboarding' &&
          state.matchedLocation != '/splash') {
        return '/onboarding';
      }
      
      return null; // No redirect needed
    },
    
    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: '/auth',
        builder: (context, state) => const SizedBox.shrink(),
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
      
      // Main App Routes
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/formations',
            name: 'formations',
            builder: (context, state) => const FormationsPage(),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServicesPage(),
          ),
          GoRoute(
            path: '/events',
            name: 'events',
            builder: (context, state) => const EventsPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      
      // Admin Routes
      GoRoute(
        path: '/admin',
        builder: (context, state) => const SizedBox.shrink(),
        routes: [
          GoRoute(
            path: 'login',
            name: 'admin-login',
            builder: (context, state) => const AdminLoginPage(),
          ),
          GoRoute(
            path: 'dashboard',
            name: 'admin-dashboard',
            builder: (context, state) => const AdminDashboardPage(),
          ),
        ],
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Main Shell for the authenticated app
/// This provides the bottom navigation bar and common layout
class MainShell extends StatelessWidget {
  final Widget child;
  
  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Formations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Événements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case '/home':
        return 0;
      case '/formations':
        return 1;
      case '/services':
        return 2;
      case '/events':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/formations');
        break;
      case 2:
        context.go('/services');
        break;
      case 3:
        context.go('/events');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}

/// Route transitions
class CustomPageTransition extends CustomTransitionPage<void> {
  const CustomPageTransition({
    required super.child,
    required super.key,
    required super.name,
    super.arguments,
  }) : super(
    transitionsBuilder: _fadeTransitionBuilder,
    transitionDuration: const Duration(milliseconds: 300),
  );

  static Widget _fadeTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

/// Slide transition for specific routes
class SlidePageTransition extends CustomTransitionPage<void> {
  const SlidePageTransition({
    required super.child,
    required super.key,
    required super.name,
    super.arguments,
  }) : super(
    transitionsBuilder: _slideTransitionBuilder,
    transitionDuration: const Duration(milliseconds: 300),
  );

  static Widget _slideTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
