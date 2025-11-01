@echo off
echo Cleaning Flutter project...
flutter clean
echo.
echo Getting dependencies...
flutter pub get
echo.
echo Building APK...
flutter build apk
echo.
echo Build completed successfully!
pause