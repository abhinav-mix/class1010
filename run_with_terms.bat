@echo off
cls
echo ==========================================
echo    RUNNING APP WITH TERMS & CONDITIONS
echo ==========================================
echo.

echo 1. Installing dependencies...
flutter pub get
echo Done!
echo.

echo 2. Cleaning previous builds...
flutter clean
echo Done!
echo.

echo 3. Getting packages...
flutter pub get
echo Done!
echo.

echo 4. Running the app...
echo The app now includes Terms & Conditions that must be accepted before login.
echo.
flutter run

echo.
echo App execution completed.
pause