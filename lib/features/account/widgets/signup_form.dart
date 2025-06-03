import 'package:calderum/core/widgets/app_loader.dart';
import 'package:calderum/core/widgets/calderum_button.dart';
import 'package:calderum/core/widgets/calderum_text_form_field.dart';
import 'package:calderum/features/account/viewmodels/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupForm extends ConsumerWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signUpViewModelProvider);
    final signupNotifier = ref.read(signUpViewModelProvider.notifier);

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final userNameController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Create an Account',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        CalderumTextField(
          controller: userNameController,
          hint: 'Username',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_\.\-]')),
            LengthLimitingTextInputFormatter(20),
          ],
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        CalderumTextField(
          controller: confirmPasswordController,
          hint: 'Confirm Password',
          obscureText: true,
        ),
        const SizedBox(height: 24),
        signupState.isLoading
            ? const AppLoader()
            : SizedBox(
                width: double.infinity,
                child: CalderumButton(
                  filled: true,
                  label: 'Sign Up',
                  onPressed: () async {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }
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
                ),
              ),
        TextButton(
          onPressed: () {
            context.go('/login');
          },
          child: const Text('Already have an account? Log in'),
        ),
      ],
    );
  }
}
