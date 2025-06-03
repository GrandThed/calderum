import 'package:supabase_flutter/supabase_flutter.dart';

class GlobalServices {
  static final SupabaseClient _client = Supabase.instance.client;

  // Access to client
  static SupabaseClient get client => _client;

  // Session helpers
  static User? get currentUser => _client.auth.currentUser;
  static String? get currentUserId => currentUser?.id;
  static bool get isLoggedIn => currentUser != null;

  // For debugging
  static void log(String message) {
    print('[GLOBAL] $message');
  }
}
