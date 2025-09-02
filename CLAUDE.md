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
- ✅ **Anonymous-first authentication system** with Firebase Anonymous Auth
- ✅ **Optional login** - Players can play immediately without signing up
- ✅ **Random mage names** for anonymous users (e.g., "Gandalf (Anonymous)")
- ✅ **Login prompts** at profile and match end to save progress
- ✅ **Account linking** - Anonymous users can link to email/Google accounts
- ✅ **Instant room creation** - Click "Create Room" immediately creates a room with default settings
- ✅ **In-lobby settings** - Host can modify room settings from the lobby view (no separate configuration screen)
- ✅ Streamlined home page with direct room code input and paste functionality
- ✅ Dynamic room capacity (2-4 players configurable by host in lobby)
- ✅ **Duplicate room prevention** - Returns existing waiting room if user already has one
- ✅ **Room settings dialog** - Max players, ingredient set, test tube variant (accessible from lobby)
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

## Authentication Workflow
- **Anonymous Start**: App launches directly to home page with random mage name (e.g., "Merlin (Anonymous)")
- **Immediate Play**: Users can create/join rooms instantly without any signup
- **Data Persistence**: Anonymous users are saved to Firestore for game continuity and room persistence
- **Optional Login**: Login prompts appear at profile section and after completing matches
- **Account Linking**: Anonymous users can link to email/password or Google accounts
- **Seamless Migration**: Account linking preserves same UID, all room memberships, game stats, and progress
- **No Room Updates Needed**: Firebase account linking maintains same UID across anonymous → authenticated transition
- **No Auth Guards**: All app features accessible without authentication
- **Firebase Anonymous Auth**: Uses Firebase's built-in anonymous authentication system
- **Random Mage Names**: 60+ fantasy/pop culture mage names (Gandalf, Dumbledore, Strange, etc.)

## Room Management Workflow
- **Instant Room Creation**: Click "Create Room" immediately creates a room with default settings (max 4 players, ingredient set 1, no test tube)
- **Duplicate Prevention**: If user already has a waiting room (as host or player), returns that room instead of creating a new one
- **Code-Based Joining**: Each room has a unique 6-character code (letters/numbers)
- **Direct Input**: Home page has a room code field with paste functionality
- **Auto-Join**: Pasting a valid 6-character code automatically attempts to join
- **Dynamic Capacity**: Rooms support 2-4 players (configurable by host)
- **No Separate Join Page**: Streamlined UX with everything on the home page
- **Room Settings**: Host can configure max players (2-4), ingredient set (1-4), and test tube variant from lobby
- **Expandable Settings Panel**: In-room settings configuration with animated expand/collapse
- **Real-time Updates**: All players see setting changes immediately via Firestore streams

## Important Architectural Decisions
1. **Anonymous-First**: No required login - players start as anonymous with random mage names
2. **Optional Authentication**: Login prompts at profile and match end to save progress
3. **Firebase Anonymous Auth**: Uses Firebase's native anonymous authentication system
4. **Account Linking**: Anonymous users can upgrade to full accounts (email/Google)
5. **No Mid-Game Joining**: Players cannot join games after they have started - no spectator mode
6. **No Public Rooms**: All games are private/invitation-based (code-based)
7. **Firebase Exclusive**: All backend services through Firebase
8. **Simultaneous Play**: Potions phase is simultaneous for all players (no turn timers needed)
9. **Instant Creation**: Rooms created immediately without configuration screens
10. **Code Sharing**: Primary method of room discovery via 6-character codes
11. **Pre-Game Only**: Players must join rooms before game starts - rooms lock at game start
12. **11 Achievements**: Simple achievement system (wins + ingredients)
13. **Friends System**: Recent players recommendations
14. **No Monetization**: Free-to-play, no shop or purchases
15. **No Leaderboards**: Focus on friend-based competition
16. **Emotes Only**: No text chat, just reaction buttons

## Recent UI/UX Improvements
- **Animated Refresh Button**: 360-degree rotation animation when refreshing room lists for better visual feedback
- **Unified Create Room Card**: Create button redesigned to match room card styling with gradient backgrounds and consistent visual hierarchy
- **Enhanced Color Scheme**: Paste room code button now uses magical theme colors (gold for paste, purple for join) with smooth transitions
- **Expandable Settings Panel**: Room settings integrated into lobby with animated expand/collapse functionality, only editable by host during waiting state
- **Enhanced Player Cards**: Redesigned player list with:
  - Subtle "YOU" corner ribbon instead of subtitle line for space efficiency
  - Integrated host badge with crown icon and gold theming
  - Visual gradients and shadows for current user highlighting
  - Improved ready/waiting status indicators with icons
  - Consistent avatar colors based on player names
- **Micro-interactions**: Added scale animations, hover effects, and magical glow enhancements throughout the interface
- **Accessibility**: High contrast ratios, keyboard navigation support, and reduced motion preferences