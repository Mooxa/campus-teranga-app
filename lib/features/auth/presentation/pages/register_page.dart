import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/app_providers.dart';

/// Modern Register Page
/// 
/// This page provides:
/// - Clean, modern Material 3 design
/// - Comprehensive form validation
/// - Email format validation
/// - Password strength validation
/// - Password confirmation matching
/// - Loading indicators and feedback
/// - Responsive design
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            print('🔙 [REGISTER] Back button pressed');
            if (context.canPop()) {
              print('✅ [REGISTER] Can pop - going back');
              context.pop();
            } else {
              print('🔄 [REGISTER] Cannot pop - navigating to login');
              context.go('/auth/login');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(theme),
                
                const SizedBox(height: 32),
                
                // Registration form
                Form(
                  key: _formKey,
                  child: _buildRegistrationForm(theme),
                ),
                
                const SizedBox(height: 24),
                
                // Terms and conditions
                _buildTermsAndConditions(theme),
                
                const SizedBox(height: 24),
                
                // Register button
                _buildRegisterButton(theme),
                
                const SizedBox(height: 16),
                
                // Login link
                _buildLoginLink(theme),
              ],
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
            Icons.person_add_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Créer un compte',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rejoignez la communauté Campus Téranga',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(ThemeData theme) {
    return Column(
      children: [
        // Full Name Field
        TextFormField(
          controller: _fullNameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Nom complet',
            prefixIcon: const Icon(Icons.person_outline),
            hintText: 'Votre nom et prénom',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre nom complet';
            }
            if (value.trim().split(' ').length < 2) {
              return 'Veuillez entrer votre nom et prénom';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),
        
        // Phone Number Field
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Numéro de téléphone',
            prefixIcon: const Icon(Icons.phone_outlined),
            hintText: '221771234567',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre numéro de téléphone';
            }
            if (value.length < 9) {
              return 'Le numéro de téléphone doit contenir au moins 9 chiffres';
            }
            // Basic phone validation (digits only)
            if (!RegExp(r'^\d+$').hasMatch(value)) {
              return 'Le numéro de téléphone ne doit contenir que des chiffres';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),
        
        // Email Field
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email (optionnel)',
            prefixIcon: const Icon(Icons.email_outlined),
            hintText: 'votre.email@exemple.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Veuillez entrer une adresse email valide';
              }
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),
        
        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Au moins 8 caractères',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un mot de passe';
            }
            if (value.length < 8) {
              return 'Le mot de passe doit contenir au moins 8 caractères';
            }
            // Password strength validation
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return 'Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),
        
        // Confirm Password Field
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Répétez votre mot de passe',
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez confirmer votre mot de passe';
            }
            if (value != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'J\'accepte les '),
                    TextSpan(
                      text: 'conditions d\'utilisation',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' et la '),
                    TextSpan(
                      text: 'politique de confidentialité',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _isLoading || !_acceptTerms ? null : _handleRegister,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Créer mon compte'),
      ),
    );
  }

  Widget _buildLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte ? ',
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            context.go('/auth/login');
          },
          child: const Text('Se connecter'),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    print('🚀 [REGISTER] Starting registration process...');
    
    if (!_formKey.currentState!.validate()) {
      print('❌ [REGISTER] Form validation failed');
      return;
    }

    if (!_acceptTerms) {
      print('❌ [REGISTER] Terms not accepted');
      _showErrorSnackBar('Veuillez accepter les conditions d\'utilisation');
      return;
    }

    // Get form data
    final fullName = _fullNameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final email = _emailController.text.trim().isEmpty ? null : _emailController.text.trim();
    final password = _passwordController.text;

    print('📝 [REGISTER] Form data:');
    print('   - Full Name: $fullName');
    print('   - Phone: $phoneNumber');
    print('   - Email: ${email ?? "Not provided"}');
    print('   - Password: ${password.length} characters');

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔗 [REGISTER] Calling auth state provider...');
      final authState = ref.read(authStateProvider.notifier);
      
      print('📤 [REGISTER] Sending registration request...');
      await authState.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        confirmPassword: password, // Use the same password as confirmation
      );

      print('✅ [REGISTER] Registration request completed');

      if (mounted) {
        // Check if registration was successful
        final isAuthenticated = ref.read(authStateProvider);
        print('🔍 [REGISTER] Authentication status: $isAuthenticated');
        
        if (isAuthenticated) {
          print('🎉 [REGISTER] Registration successful! Navigating to home...');
          _showSuccessSnackBar('Compte créé avec succès!');
          context.go('/home');
        } else {
          print('❌ [REGISTER] Registration failed - not authenticated');
          _showErrorSnackBar('Échec de la création du compte. Veuillez réessayer.');
        }
      }
    } catch (e) {
      print('💥 [REGISTER] Registration error: $e');
      print('📊 [REGISTER] Error type: ${e.runtimeType}');
      print('📊 [REGISTER] Error details: ${e.toString()}');
      
      if (mounted) {
        // Extract error message from exception
        String errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }
        print('📝 [REGISTER] User-friendly error: $errorMessage');
        _showErrorSnackBar('Erreur lors de la création du compte: $errorMessage');
      }
    } finally {
      if (mounted) {
        print('🔄 [REGISTER] Resetting loading state');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.error,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Fermer',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.tertiary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}