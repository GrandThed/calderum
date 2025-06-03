import 'package:calderum/core/widgets/app_loader.dart';
import 'package:calderum/core/widgets/calderum_text_form_field.dart';
import 'package:calderum/features/account/viewmodels/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});
  static const routeName = '/signup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signUpViewModelProvider);
    final signupNotifier = ref.read(signUpViewModelProvider.notifier);

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create an Account',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                CalderumTextField(
                  controller: emailController,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                CalderumTextField(
                  controller: passwordController,
                  hint: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                signupState.isLoading
                    ? const AppLoader()
                    : ElevatedButton(
                        onPressed: () async {
                          await signupNotifier.signUp(
                            emailController.text.trim(),
                            passwordController.text,
                          );

                          final error = signupState.hasError
                              ? signupState.error.toString()
                              : null;

                          if (error != null && context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(error)));
                          } else {
                            context.go('/home');
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                TextButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
