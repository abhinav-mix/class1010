@echo off
echo Cleaning Gradle Cache...
echo.

echo Stopping any running Gradle daemons...
cd android
gradlew --stop
cd ..

echo.
echo Cleaning Gradle cache...
rd /s /q "%USERPROFILE%\.gradle\caches" 2>nul

echo.
echo Cleaning Flutter build cache...
flutter clean

echo.
echo Getting fresh dependencies...
flutter pub get

echo.
echo Gradle cache cleaned successfully!
echo You can now try running your app again.
pause