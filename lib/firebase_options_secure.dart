import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Secure [FirebaseOptions] that loads credentials from environment variables
///
/// This approach keeps sensitive API keys out of version control
/// Make sure to load dotenv before initializing Firebase:
/// ```dart
/// await dotenv.load(fileName: ".env");
/// await Firebase.initializeApp(
///   options: SecureFirebaseOptions.currentPlatform,
/// );
/// ```
class SecureFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'SecureFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'SecureFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.env['WEB_API_KEY'] ?? '',
    appId: dotenv.env['WEB_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['WEB_MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['WEB_PROJECT_ID'] ?? '',
    authDomain: dotenv.env['WEB_AUTH_DOMAIN'] ?? '',
    storageBucket: dotenv.env['WEB_STORAGE_BUCKET'] ?? '',
    measurementId: dotenv.env['WEB_MEASUREMENT_ID'],
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: dotenv.env['ANDROID_API_KEY'] ?? '',
    appId: dotenv.env['ANDROID_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? '',
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: dotenv.env['IOS_API_KEY'] ?? '',
    appId: dotenv.env['IOS_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? '',
    iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? '',
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: dotenv.env['IOS_API_KEY'] ?? '',
    appId: dotenv.env['IOS_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['PROJECT_ID'] ?? '',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? '',
    iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? '',
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: dotenv.env['WINDOWS_API_KEY'] ?? '',
    appId: dotenv.env['WINDOWS_APP_ID'] ?? '',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
    projectId: dotenv.env['PROJECT_ID'] ?? '',
    authDomain: dotenv.env['WEB_AUTH_DOMAIN'] ?? '',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? '',
    measurementId: dotenv.env['WINDOWS_MEASUREMENT_ID'],
  );
}
