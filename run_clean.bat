@echo off
echo Cleaning Flutter project...
flutter clean
echo.
echo Getting dependencies...
flutter pub get
echo.
echo Starting the app...
flutter run
pause