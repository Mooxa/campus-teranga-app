import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';

/// Progress indicator widget for onboarding
/// 
/// This widget provides:
/// - Visual progress indication
/// - Smooth animations
/// - Customizable styling
/// - Responsive design
class OnboardingIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;

  const OnboardingIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = this.activeColor ?? theme.colorScheme.primary;
    final inactiveColor = this.inactiveColor ?? theme.colorScheme.onSurface.withOpacity(0.3);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalPages,
        (index) {
          final isActive = index == currentPage;
          final isCompleted = index < currentPage;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildIndicator(
              isActive: isActive,
              isCompleted: isCompleted,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              index: index,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicator({
    required bool isActive,
    required bool isCompleted,
    required Color activeColor,
    required Color inactiveColor,
    required int index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive || isCompleted ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive ? [
          BoxShadow(
            color: activeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: isActive
          ? Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
              .animate()
              .scale(
                begin: const Offset(0.0, 0.0),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
                curve: Curves.elasticOut,
              ),
            )
          : isCompleted
              ? Center(
                  child: Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(1.0, 1.0),
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                  ),
                )
              : null,
    );
  }
}
