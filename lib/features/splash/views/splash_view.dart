import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_loading.dart';
import '../../../shared/constants/route_paths.dart';
import '../../../shared/providers/providers.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      final authState = ref.read(authStateChangesProvider);
      authState.when(
        data: (user) {
          if (user != null) {
            context.go(RoutePaths.home);
          } else {
            context.go(RoutePaths.login);
          }
        },
        loading: () {},
        error: (_, __) => context.go(RoutePaths.login),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.science,
              size: 120,
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Calderum',
              style: AppTheme.headlineStyle.copyWith(fontSize: 48),
            ),
            const SizedBox(height: 48),
            const CalderumLoading(
              message: 'Preparing your cauldron...',
            ),
          ],
        ),
      ),
    );
  }
}