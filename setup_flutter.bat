@echo off
echo Setting Flutter PATH for this session...
set PATH=C:\flutter_sdk\flutter\bin;%PATH%
echo Flutter is now available in this session.
echo.
echo To make this permanent, add C:\flutter_sdk\flutter\bin to your system PATH:
echo 1. Open System Properties (Win + X, then Y)
echo 2. Click "Environment Variables"
echo 3. Under "System variables", find and select "Path", click "Edit"
echo 4. Click "New" and add: C:\flutter_sdk\flutter\bin
echo 5. Click OK on all windows
echo.
flutter --version