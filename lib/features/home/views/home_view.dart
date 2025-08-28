import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/calderum_app_bar.dart';
import '../../../shared/widgets/calderum_button.dart';
import '../../../shared/constants/route_paths.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CalderumAppBar(
        title: 'Calderum',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => context.push(RoutePaths.profile),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.science,
                      size: 80,
                      color: AppTheme.secondaryColor,
                    ),
                    const SizedBox(height: 20),
                    Text('Ready to Brew?', style: AppTheme.headlineStyle),
                    const SizedBox(height: 8),
                    Text(
                      'Create or join a magical brewing session',
                      style: AppTheme.bodyStyle.copyWith(color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CalderumButton(
                text: 'Create Room',
                onPressed: () => context.push(RoutePaths.createRoom),
                icon: Icons.add_circle_outline,
              ),
              const SizedBox(height: 16),
              CalderumButton(
                text: 'Join Room',
                onPressed: () => context.push(RoutePaths.joinRoom),
                isOutlined: true,
                icon: Icons.group_add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
