@echo off
cls
echo ==========================================
echo    FIXING SSL ISSUE AND RUNNING APP
echo ==========================================
echo.

echo 1. Applying SSL fix for Gradle...
call fix_gradle_ssl.bat
echo Done!
echo.

echo 2. Installing dependencies...
flutter pub get
echo.

echo 3. Running the app...
flutter run

pause