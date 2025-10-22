import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/app_providers.dart';
import '../widgets/splash_logo_widget.dart';

/// Splash Page - First screen users see when opening the app
/// 
/// This page provides:
/// - App branding and logo animation
/// - Authentication status check
/// - Automatic navigation to appropriate screen
/// - Loading states with smooth transitions
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for splash animation to complete
    await Future.delayed(const Duration(seconds: 2));
    
    // Check authentication status
    await ref.read(authStateProvider.notifier).checkAuthStatus();
    
    // Check if onboarding is completed
    final isOnboardingCompleted = true; // This would come from storage
    
    // Navigate based on app state
    if (mounted) {
      if (isOnboardingCompleted) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
                theme.colorScheme.secondary.withOpacity(0.6),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Animation
                const SplashLogoWidget(),
                
                const SizedBox(height: AppTheme.spacing['2xl']!),
                
                // App Name
                Text(
                  'Campus Téranga',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms, delay: 600.ms)
                .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: AppTheme.spacing['sm']!),
                
                // Tagline
                Text(
                  'Votre guide au Sénégal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms, delay: 800.ms)
                .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: AppTheme.spacing['3xl']!),
                
                // Loading Indicator
                _buildLoadingIndicator(),
                
                const SizedBox(height: AppTheme.spacing['lg']!),
                
                // Loading Text
                Text(
                  'Chargement...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 500.ms, delay: 1000.ms)
                .then()
                .fadeOut(duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white.withOpacity(0.8),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 600.ms, delay: 1200.ms)
    .scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: 600.ms,
    );
  }
}
