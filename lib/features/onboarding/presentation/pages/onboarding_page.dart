import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/onboarding_slide_widget.dart';
import '../widgets/onboarding_indicator_widget.dart';

/// Modern Onboarding Page with smooth animations and engaging content
/// 
/// This page provides:
/// - Multi-step onboarding flow
/// - Smooth page transitions
/// - Interactive elements
/// - Personalized content based on user type
/// - Skip functionality
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: 'Bienvenue au Sénégal',
      subtitle: 'Découvrez Campus Téranga',
      description: 'Votre guide complet pour réussir vos études au Sénégal. Formations, services, événements et communauté.',
      imagePath: 'assets/images/onboarding_1.png',
      icon: Icons.school_rounded,
      color: Colors.orange,
    ),
    OnboardingSlideData(
      title: 'Formations & Éducation',
      subtitle: 'Trouvez votre parcours',
      description: 'Découvrez les meilleures formations, universités et programmes d\'études adaptés à vos ambitions.',
      imagePath: 'assets/images/onboarding_2.png',
      icon: Icons.menu_book_rounded,
      color: Colors.blue,
    ),
    OnboardingSlideData(
      title: 'Services Pratiques',
      subtitle: 'Vie étudiante simplifiée',
      description: 'Transport, logement, procédures administratives... Tout ce dont vous avez besoin en un clic.',
      imagePath: 'assets/images/onboarding_3.png',
      icon: Icons.home_work_rounded,
      color: Colors.green,
    ),
    OnboardingSlideData(
      title: 'Communauté & Événements',
      subtitle: 'Connectez-vous',
      description: 'Rencontrez d\'autres étudiants, participez à des événements et construisez votre réseau.',
      imagePath: 'assets/images/onboarding_4.png',
      icon: Icons.people_rounded,
      color: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    // This would typically save to storage
    context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with skip button
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing['md']!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Passer',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  
                  // Progress indicator
                  OnboardingIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _slides.length,
                  ),
                ],
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return OnboardingSlideWidget(
                    data: _slides[index],
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),
            
            // Bottom navigation
            _buildBottomNavigation(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing['lg']!),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navigation buttons
          Row(
            children: [
              // Previous button
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousPage,
                    child: const Text('Précédent'),
                  ),
                ),
              
              if (_currentPage > 0) const SizedBox(width: AppTheme.spacing['md']!),
              
              // Next/Get Started button
              Expanded(
                flex: _currentPage > 0 ? 1 : 2,
                child: FilledButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Commencer' : 'Suivant',
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacing['md']!),
          
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for onboarding slides
class OnboardingSlideData {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final IconData icon;
  final Color color;

  OnboardingSlideData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.color,
  });
}
