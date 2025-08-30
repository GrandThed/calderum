import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/user_model.dart';

class AnonymousLoginPrompt extends ConsumerWidget {
  final UserModel user;
  final String context;
  final VoidCallback? onLoginSuccess;

  const AnonymousLoginPrompt({
    super.key,
    required this.user,
    this.context = 'profile',
    this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Playing as ${user.displayNameFormatted}',
              style: const TextStyle(
                fontFamily: 'Caudex',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign up to save your progress, unlock achievements, and compete with friends!',
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/login'),
                    icon: const Icon(Icons.email),
                    label: const Text('Sign In'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push('/signup'),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final authViewModel = ref.read(authViewModelProvider.notifier);
                  await authViewModel.linkAnonymousToGoogle();
                  onLoginSuccess?.call();
                },
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: 20,
                  width: 20,
                ),
                label: const Text('Continue with Google'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}