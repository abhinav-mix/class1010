@echo off
cls
echo ==========================================
echo    COMPLETE APP RUN SCRIPT
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
echo If you see deprecation warnings, they are from third-party plugins and can be ignored.
echo.
flutter run

echo.
echo App execution completed.
pause