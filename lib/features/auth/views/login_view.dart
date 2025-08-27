import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/widgets/calderum_text_field.dart';
import '../../../shared/constants/route_paths.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Calderum',
                    style: AppTheme.headlineStyle.copyWith(fontSize: 48),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Brew Your Magic',
                    style: AppTheme.bodyStyle.copyWith(
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  CalderumTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email, color: Colors.white54),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CalderumTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CalderumButton(
                    text: 'Login',
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                  CalderumButton(
                    text: 'Create Account',
                    onPressed: () => context.push(RoutePaths.signup),
                    isOutlined: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // TODO: Implement actual login logic
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(RoutePaths.home);
    }
  }
}