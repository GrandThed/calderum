import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options_secure.dart';
import 'router/app_router.dart';
import 'shared/theme/app_theme.dart';
import 'features/account/viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with secure options
  await Firebase.initializeApp(options: SecureFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: CalderumApp()));
}

class CalderumApp extends ConsumerWidget {
  const CalderumApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    // Initialize auth state by watching the AuthViewModel
    final authState = ref.watch(authViewModelProvider);
    print('🏁 App build - Auth state: ${authState.runtimeType}');

    return MaterialApp.router(
      title: 'Calderum - Hot Reload Test!',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        // Ensure text is always visible even if fonts haven't loaded
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
