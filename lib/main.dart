import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options_secure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase with secure options
  await Firebase.initializeApp(
    options: SecureFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: CalderumApp(),
    ),
  );
}

class CalderumApp extends StatelessWidget {
  const CalderumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calderum',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Caudex',
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Calderum - Firebase Secured',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
