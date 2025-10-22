import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';

/// Animated Logo Widget for Splash Screen
/// 
/// This widget provides:
/// - Animated logo with Teranga branding
/// - Smooth entrance animations
/// - Brand colors and styling
/// - Scalable design for different screen sizes
class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius['xl']!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius['xl']!),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
          ),
          
          // Logo content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main logo icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius['md']!),
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              )
              .animate()
              .scale(
                begin: const Offset(0.0, 0.0),
                end: const Offset(1.0, 1.0),
                duration: 800.ms,
                curve: Curves.elasticOut,
              )
              .then()
              .shimmer(
                duration: 1000.ms,
                color: Colors.white.withOpacity(0.3),
              ),
              
              const SizedBox(height: 8),
              
              // Logo text
              Text(
                'CT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.5,
                ),
              )
              .animate(delay: 400.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.5, end: 0),
            ],
          ),
          
          // Animated ring
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.2, 1.2),
            duration: 2000.ms,
            curve: Curves.easeInOut,
          )
          .fadeIn(
            begin: 0.0,
            end: 0.3,
            duration: 1000.ms,
          )
          .then()
          .fadeOut(
            begin: 0.3,
            end: 0.0,
            duration: 1000.ms,
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(duration: 800.ms, delay: 200.ms)
    .slideY(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
    .then()
    .shimmer(
      duration: 1500.ms,
      color: Colors.white.withOpacity(0.2),
    );
  }
}
