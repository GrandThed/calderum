import 'package:calderum/core/widgets/calderum_button.dart';
import 'package:calderum/features/account/views/signup_view.dart';
import 'package:calderum/features/account/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});
  static const routeName = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Image.asset('assets/images/login_logo.png'),
                const SizedBox(height: 24),
                LoginForm(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CalderumButton(
                    filled: true,
                    label: 'Sign Up',
                    onPressed: () {
                      context.push(SignUpView.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
