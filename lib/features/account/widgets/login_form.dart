import 'package:calderum/core/widgets/calderum_button.dart';
import 'package:calderum/core/widgets/calderum_text_form_field.dart';
import 'package:calderum/features/account/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final authNotifier = ref.read(authViewModelProvider.notifier);

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalderumTextField(
          controller: emailController,
          hint: 'Email',
          inputFormatters: [],
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        CalderumTextField(
          controller: passwordController,
          hint: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: CalderumButton(
            filled: true,
            label: 'Login',
            isLoading: authState.isLoading,
            onPressed: () async {
              await authNotifier.login(
                emailController.text,
                passwordController.text,
              );

              if (authState.hasError && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(authState.error.toString())),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
