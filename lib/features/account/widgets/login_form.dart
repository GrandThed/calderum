import 'package:calderum/core/widgets/calderum_button.dart';
import 'package:calderum/core/widgets/calderum_text_form_field.dart';
import 'package:calderum/features/account/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final authNotifier = ref.read(authViewModelProvider.notifier);

    _submitForm() async {
      if (_formKey.currentState?.validate() ?? false) {
        await authNotifier.login(emailController.text, passwordController.text);

        if (authState.hasError && context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(authState.error.toString())));
        }
      }
    }

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalderumTextField(
            textInputAction: TextInputAction.next,
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
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submitForm(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CalderumButton(
              filled: true,
              label: 'Login',
              isLoading: authState.isLoading,
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
    );
  }
}
