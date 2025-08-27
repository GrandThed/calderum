class AppConstants {
  // App Info
  static const String appName = 'Calderum';
  static const String appVersion = '1.0.0';
  
  // Game Constants
  static const int minPlayers = 2;
  static const int maxPlayers = 4;
  static const int maxRoomNameLength = 20;
  static const int maxUserNameLength = 15;
  static const int gameTimerSeconds = 30;
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String roomsCollection = 'rooms';
  static const String gamesCollection = 'games';
  static const String messagesCollection = 'messages';
  
  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String gameAssetsPath = 'game_assets';
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';
  
  // Success Messages
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String roomCreatedSuccess = 'Room created successfully!';
  static const String gameStartedSuccess = 'Game started!';
}