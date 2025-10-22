import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../pages/onboarding_page.dart';

/// Individual onboarding slide widget
/// 
/// This widget provides:
/// - Animated content display
/// - Responsive layout
/// - Beautiful illustrations
/// - Smooth transitions
class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingSlideData data;
  final bool isActive;

  const OnboardingSlideWidget({
    super.key,
    required this.data,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration/Icon
          _buildIllustration(theme),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            data.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          )
          .animate(target: isActive ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 200.ms)
          .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            data.subtitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: data.color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          )
          .animate(target: isActive ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 400.ms)
          .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 24),
          
          // Description
          Text(
            data.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
          .animate(target: isActive ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius['xl']!),
        border: Border.all(
          color: data.color.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius['xl']!),
              gradient: RadialGradient(
                colors: [
                  data.color.withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
          
          // Main icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius['lg']!),
              boxShadow: [
                BoxShadow(
                  color: data.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 40,
              color: Colors.white,
            ),
          )
          .animate(target: isActive ? 1 : 0)
          .scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
            duration: 800.ms,
            curve: Curves.elasticOut,
          )
          .then()
          .shimmer(
            duration: 2000.ms,
            color: Colors.white.withOpacity(0.3),
          ),
          
          // Decorative elements
          ...List.generate(3, (index) {
            return Positioned(
              top: 20 + (index * 40),
              right: 20 + (index * 20),
              child: Container(
                width: 8 - (index * 2),
                height: 8 - (index * 2),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            )
            .animate(target: isActive ? 1 : 0)
            .fadeIn(
              duration: 400.ms,
              delay: (800 + (index * 200)).ms,
            )
            .scale(
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 1.0),
              duration: 400.ms,
            );
          }),
        ],
      ),
    )
    .animate(target: isActive ? 1 : 0)
    .fadeIn(duration: 600.ms)
    .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic);
  }
}
