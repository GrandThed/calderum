@echo off
echo Starting Calderum Development Environment...
echo.

REM Start MCP Server in background
echo Starting Dart MCP Server...
start /b dart mcp-server > nul 2>&1
echo MCP Server started in background

REM Optional: Start Flutter development server
echo.
echo MCP Server is running. You can now:
echo 1. Run 'flutter run' to start the app
echo 2. Run 'dart run build_runner watch' for code generation
echo 3. The MCP server will provide AI assistance for your development
echo.
echo Press any key to stop the MCP server and exit...
pause > nul

REM Kill MCP server when done
taskkill /IM dart.exe /F > nul 2>&1
echo MCP Server stopped.