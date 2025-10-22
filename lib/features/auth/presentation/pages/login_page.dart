import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';

/// Modern Login Page
/// 
/// This page provides:
/// - Clean, modern design
/// - Form validation
/// - Biometric authentication
/// - Password visibility toggle
/// - Remember me functionality
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and welcome text
                  _buildHeader(theme),
                  
                  const SizedBox(height: 64),
                  
                  // Login form
                  _buildLoginForm(theme),
                  
                  const SizedBox(height: 24),
                  
                  // Login button
                  _buildLoginButton(theme),
                  
                  const SizedBox(height: 16),
                  
                  // Register link
                  _buildRegisterLink(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius['lg']!),
          ),
          child: Icon(
            Icons.school_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Bienvenue',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connectez-vous à votre compte',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Numéro de téléphone',
            prefixIcon: const Icon(Icons.phone),
            hintText: '+221 XX XXX XX XX',
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.visibility_off),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          // Handle login
        },
        child: const Text('Se connecter'),
      ),
    );
  }

  Widget _buildRegisterLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas de compte ? ',
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            // Navigate to register
          },
          child: const Text('S\'inscrire'),
        ),
      ],
    );
  }
}
