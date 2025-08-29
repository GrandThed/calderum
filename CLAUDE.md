# Calderum Project

## Project Overview
A digital adaptation of The Quacks of Quedlinburg board game, featuring push-your-luck bag-building mechanics where players compete as alchemists brewing magical potions. Built with Flutter and Firebase for cross-platform multiplayer gameplay with dynamic room management.

## Tech Stack
- **Framework**: Flutter 3.35.2 (Dart SDK 3.9.0)
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

# Run the app (USER WILL RUN THIS - NEVER run flutter automatically)
flutter run

# Run tests
flutter test

# Format code
dart format .

# Analyze code
flutter analyze
```

## Important Development Notes
- **NEVER run `flutter run` automatically** - The user will handle running Flutter themselves
- Always wait for the user to start the Flutter development server
- **ALWAYS ask for the DTD URI before starting development** - Required for connecting to Dart Tooling Daemon
- User should use "Copy DTD Uri to clipboard" action in their IDE
- **When hot reload fails, analyze the code for errors first** - Use `mcp__dart-mcp__analyze_files` to check for compilation errors that prevent hot reload from working

## Current Status
Phase 0 (Foundation) and Phase 1 (Room Management) are complete. See `task.md` for detailed progress tracking.
- ✅ Authentication system complete with Firebase (Google Sign-In integrated)
- ✅ User profile management implemented
- ✅ Room management system with instant creation and code-based joining
- ✅ Streamlined home page with direct room code input and paste functionality
- ✅ Dynamic room capacity (1-4 players, joins as players enter)
- Using Riverpod for state management
- Custom UI components with magical theme (Caudex and Caveat fonts)
- Simple geometric ingredient icons for accessibility

## Game Rules Reference
See `game_rules.md` for complete Quacks of Quedlinburg game mechanics:
- 9-turn structure with Fortune Teller cards
- Bag-building with ingredient chips (white, orange, yellow, green, blue, red, purple, black)
- Push-your-luck mechanics (white chips cause explosions at 7+ total)
- Ingredient Sets 1-4 with different abilities
- Test tube variant for advanced play
- Simultaneous potion brewing phase
- Evaluation phases A-F (Bonus Die, Chip Actions, Rubies, Victory Points, Buy Chips, End Turn)
- Rat catch-up mechanism for trailing players

## Environment Setup
- **Flutter Version**: 3.35.2 (stable channel)
- **Dart SDK**: 3.9.0
- Requires Firebase configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS)
- Uses flutter_dotenv for additional environment configuration

## Development Notes
- Models use freezed for immutability and code generation
- ViewModels use riverpod_generator for dependency injection
- Follow feature-based folder structure
- All generated files use `.g.dart` and `.freezed.dart` extensions
- Update any change into the mcp server
- Firebase-only architecture (no external services)
- Private rooms only (invitation-based)
- Simultaneous Potions phase (not turn-based)

## MCP Server Setup
The project uses Dart's native MCP (Model Context Protocol) server for AI-assisted development.

### Auto-start on Development
**IMPORTANT**: Always start the MCP server at the beginning of each development session:
```bash
# Windows
start_dev.bat

# Or manually start MCP server
dart mcp-server
```

### Configuration
- MCP configuration is in `.mcp.json`
- The server provides intelligent code assistance for Dart/Flutter development
- Automatically syncs with project changes for context-aware suggestions

### Development Workflow
1. Start MCP server first (via `start_dev.bat` or manually)
2. Make code changes - MCP server will track them
3. Use AI assistance for code generation, refactoring, and debugging
4. MCP server stops automatically when development session ends

## Firebase Security Setup 🔒
The project implements secure Firebase credential management to protect sensitive API keys.

### Security Implementation
- **Environment Variables**: All Firebase credentials stored in `.env` file
- **Version Control**: `.env` file excluded from Git via `.gitignore`
- **Example Template**: `.env.example` shows required structure without sensitive values
- **Secure Initialization**: `firebase_options_secure.dart` loads credentials from environment

### Setup Instructions
1. Copy `.env.example` to `.env`
2. Fill in your actual Firebase credentials in `.env`
3. Use `main_secure.dart` for secure Firebase initialization
4. **NEVER** commit `.env` to version control

### Security Best Practices
- Regularly rotate Firebase API keys
- Use Firebase Security Rules to restrict database access
- Enable Firebase App Check for additional security
- Monitor Firebase usage for suspicious activity
- Never commit `.env` file to version control
- Use different Firebase projects for development/staging/production

### Files Overview
- `.env` - Contains sensitive Firebase credentials (excluded from Git)
- `.env.example` - Template showing required environment variables
- `firebase_options_secure.dart` - Secure Firebase options using environment variables
- `main.dart` - Entry point with secure Firebase initialization

## Key Documentation Files
- `game_rules.md` - Complete Quacks of Quedlinburg rules reference
- `requirements.md` - Detailed functional and technical requirements
- `design.md` - UI/UX specifications and screen layouts
- `task.md` - Development roadmap and sprint planning

## Room Management Workflow
- **Instant Room Creation**: Click "Create Room" immediately creates a room with default settings (max 4 players, all ingredient sets, 30s timers)
- **Code-Based Joining**: Each room has a unique 6-character code (letters/numbers)
- **Direct Input**: Home page has a room code field with paste functionality
- **Auto-Join**: Pasting a valid 6-character code automatically attempts to join
- **Dynamic Capacity**: Rooms adjust to 1-4 players as people join/leave
- **No Separate Join Page**: Streamlined UX with everything on the home page

## Important Architectural Decisions
1. **Dynamic Rooms**: Players can join/leave games in progress
2. **No Public Rooms**: All games are private/invitation-based (code-based)
3. **Firebase Exclusive**: All backend services through Firebase
4. **Simultaneous Play**: Potions phase is not turn-based
5. **Instant Creation**: Rooms created immediately without configuration screens
6. **Code Sharing**: Primary method of room discovery via 6-character codes
7. **Backend XP**: Experience system tracked but no UI yet
8. **11 Achievements**: Simple achievement system (wins + ingredients)
9. **Friends System**: Recent players recommendations
10. **No Monetization**: Free-to-play, no shop or purchases
11. **No Leaderboards**: Focus on friend-based competition
12. **Emotes Only**: No text chat, just reaction buttons