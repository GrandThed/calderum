# Dart MCP Server Troubleshooting Session

## Problem Description
- Issue with Dart MCP server: https://github.com/dart-lang/sdk/issues/61365
- JSON parsing errors when running `dart mcp-server`
- Windows path resolution issues with file URIs

## Environment Before Fix
- **Dart SDK**: 3.10.0-75.1.beta (beta channel)
- **Flutter**: 3.36.0-0.2.pre (beta channel)
- **Platform**: Windows (Spanish locale)
- **Error**: `{"jsonrpc":"2.0","error":{"code":-32700,"message":"Invalid JSON: Unexpected end of input","data":{"request":""}}}`

## Solutions Applied

### 1. Switch Flutter to Stable Channel
The main fix for the JSON parsing issue was switching from Flutter beta to stable channel:

```bash
flutter channel stable
flutter upgrade
flutter clean
dart pub cache clean --force
```

**Result**: 
- Flutter: 3.35.2 (stable)
- Dart: 3.9.0 (stable)
- JSON parsing errors resolved

### 2. Update Project Flutter Version Constraints
Updated `pubspec.yaml` to specify stable Flutter version:
```yaml
environment:
  sdk: ">=3.9.0 <4.0.0"
  flutter: ">=3.35.2"
```

Updated `CLAUDE.md` documentation:
```markdown
## Tech Stack
- **Framework**: Flutter 3.35.2 (Dart SDK 3.9.0)

## Environment Setup
- **Flutter Version**: 3.35.2 (stable channel)
- **Dart SDK**: 3.9.0
```

### 3. Fix Windows Path Issues
The MCP server had Windows file path resolution problems. Added `--force-roots-fallback` flag to `.mcp.json`:

```json
{
  "mcpServers": {
    "dart-mcp": {
      "command": "dart",
      "args": ["mcp-server", "--force-roots-fallback"],
      "env": {
        "DART_SDK": "C:\\flutter_sdk\\flutter\\bin\\cache\\dart-sdk",
        "FLUTTER_SDK": "C:\\flutter_sdk\\flutter"
      }
    }
  }
}
```

## MCP Server Test Results (Current Session - August 28, 2025)

### ✅ Working Features (After Fixes)
- `mcp__dart-mcp__add_roots` - Successfully added project roots
- `mcp__dart-mcp__analyze_files` - Found 22 analysis issues (deprecation warnings)
- `mcp__dart-mcp__pub_dev_search` - Package search works perfectly (searched "riverpod flutter")
- `mcp__dart-mcp__pub` - `pub get` executed successfully 
- `mcp__dart-mcp__dart_format` - Formatted 33 files (27 changed) in 1.93 seconds
- `mcp__dart-mcp__run_tests` - All tests passed!

### ❌ DTD-Dependent Features (Requires Running App Connection)
- `mcp__dart-mcp__connect_dart_tooling_daemon` - Requires DTD URI from running Flutter app
- `mcp__dart-mcp__hot_reload` - Needs DTD connection
- `mcp__dart-mcp__get_widget_tree` - Needs DTD connection
- `mcp__dart-mcp__get_runtime_errors` - Needs DTD connection

### 🔧 Issues Resolved This Session
1. **All Windows path resolution issues** - `--force-roots-fallback` flag working correctly
2. **Android build configuration** - Created missing `local.properties` file

**Previous Error Pattern** (Now Fixed):
```
PathNotFoundException: Exists failed, path = '\\c\code\calderum' 
(OS Error: No se ha encontrado la ruta de acceso de la red., errno = 53)
```

## Technical Details

### Windows File URI Format Issues
- Windows uses backslashes (`\`) but Dart expects forward slashes (`/`) in file URIs
- Correct Windows file URI format: `file:///C:/path/to/project`
- MCP server struggles with Windows path conversion between URI and file system paths

### Root Cause Analysis
1. **Beta Channel Instability**: Flutter beta channel had JSON parsing compatibility issues with MCP server
2. **Windows Path Handling**: MCP server expected Unix-style paths but struggled with Windows path conversion
3. **File URI Resolution**: Server couldn't properly resolve `file://C:\code\calderum` format

## Key Learnings

### Flutter Channel Management
- Always use stable channel for production/development tools
- Beta channels can have compatibility issues with external tools
- `flutter channel stable && flutter upgrade` fixes many tool compatibility issues

### Windows Development Considerations  
- File URI format matters: `file:///C:/` vs `file://C:\`
- Spanish locale error messages can make debugging harder
- `--force-roots-fallback` flag helps with path resolution issues

### MCP Server Configuration
- The `--force-roots-fallback` flag bypasses strict Windows file path validation
- Environment variables for SDK paths are important for proper operation
- Testing individual MCP functions helps identify specific failure points

## Commands Used

### Diagnosis
```bash
dart --version
flutter --version
tasklist | findstr flutter  # Check running processes
```

### Fixes Applied
```bash
flutter channel stable
flutter upgrade  
flutter clean
dart pub cache clean --force
flutter pub get
```

### MCP Testing
```bash
# These work:
mcp__dart-mcp__pub_dev_search
mcp__dart-mcp__analyze_files

# These failed before --force-roots-fallback:
mcp__dart-mcp__dart_format
mcp__dart-mcp__run_tests
mcp__dart-mcp__pub
```

## Android Configuration Fix (August 28, 2025)

### Problem: Missing local.properties File
Flutter test app Android build was failing with:
```
Settings file 'C:\code\calderum\mcp_flutter\flutter_test_app\android\settings.gradle.kts' line: 4
C:\code\calderum\mcp_flutter\flutter_test_app\android\local.properties (El sistema no puede encontrar el archivo especificado)
```

### Solution: Create local.properties
Created `C:\code\calderum\mcp_flutter\flutter_test_app\android\local.properties` with:
```properties
flutter.sdk=C:\\flutter_sdk\\flutter
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
```

## DTD Connection Troubleshooting

### Issue: DTD Option Not Appearing in VS Code
The "Copy DTD URI" command doesn't appear in VS Code Command Palette.

### Possible Causes & Solutions:
1. **Flutter Extension Not Updated** - Update Dart/Flutter extensions
2. **App Not in Debug Mode** - Ensure `flutter run` (not `--release`)
3. **Try Alternative Commands**:
   - "Dart: Copy DTD URI"
   - "Flutter: Copy DTD URI" 
   - "Developer: Copy DTD URI"
4. **Manual Detection** - Check terminal output for DTD service messages
5. **Flutter DevTools** - Find DTD URI in DevTools settings

## Current Status Summary

### ✅ Fully Working
- All MCP server static analysis tools
- Code formatting and testing
- Package management
- Windows path resolution

### ⏳ Pending
- DTD connection for live debugging features
- Hot reload testing
- Widget inspection

## Future Prevention
1. Always use Flutter stable channel for development tools
2. Include `--force-roots-fallback` in MCP server configuration on Windows
3. Specify exact Flutter/Dart versions in project documentation
4. Test MCP server functionality after any Flutter/Dart version changes
5. **Always create `local.properties` for Android projects**
6. **Ensure Flutter apps run in debug mode for DTD access**

## References
- GitHub Issue: https://github.com/dart-lang/sdk/issues/61365
- Multiple users reported Flutter stable channel resolved the JSON parsing issue
- Windows file URI handling issues documented in various Dart SDK issues
- DTD (Dart Tooling Daemon) documentation: https://dart.dev/tools/dart-devtools