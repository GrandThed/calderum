# Calderum Project

## Project Overview
A magical potion brewing board game app inspired by Pócimas y Brebajes, built with Flutter and Firebase.

## Tech Stack
- **Framework**: Flutter (Dart SDK 3.4.1)
- **State Management**: Riverpod (flutter_riverpod, riverpod_annotation)
- **Routing**: go_router
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Code Generation**: freezed, json_serializable, build_runner
- **Architecture**: MVVM with feature-based structure

## Project Structure
```
lib/
├── features/           # Feature modules
│   ├── account/       # Authentication & user management
│   ├── home/          # Home view and navigation
│   └── room/          # Game room management
├── shared/            # Shared components and utilities
├── router.dart        # App routing configuration
└── main.dart          # Entry point
```

## Key Commands
```bash
# Generate code (freezed models, riverpod providers)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes and generate
dart run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test

# Format code
dart format .

# Analyze code
flutter analyze
```

## Current Status
- Authentication system being migrated to Firebase
- Room management system in development
- Using Riverpod for state management
- Custom UI components with Caudex and Caveat fonts

## Environment Setup
- Requires Firebase configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS)
- Uses flutter_dotenv for additional environment configuration

## Development Notes
- Models use freezed for immutability and code generation
- ViewModels use riverpod_generator for dependency injection
- Follow feature-based folder structure
- All generated files use `.g.dart` and `.freezed.dart` extensions