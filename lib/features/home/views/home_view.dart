import 'package:calderum/core/widgets/calderum_app_bar.dart';
import 'package:calderum/features/account/repositories/auth_repository.dart';
import 'package:calderum/features/account/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  static const routeName = '/home';

  @override
  ConsumerState<HomeView> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authRepositoryProvider);
    final email = authUser.value?.email ?? 'Guest';

    return Scaffold(
      appBar: const CalderumAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // logout
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                ref.read(authViewModelProvider.notifier).logout();
                context.go('/');
              },
            ),
            Text(
              'Welcome, $email',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
