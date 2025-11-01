@echo off
title Flutter App Fix and Run
echo ========================================
echo Flutter App - Complete Fix Solution
echo ========================================
echo.
echo This script will help you fix the SSL certificate issues and run your Flutter app.
echo.
echo Step 1: Enable Developer Mode
echo ----------------------------
echo Please make sure Developer Mode is enabled:
echo 1. Press Win + I to open Settings
echo 2. Go to Privacy & security ^> For developers
echo 3. Toggle "Developer Mode" to ON
echo.
pause
echo.
echo Step 2: Setting Environment Variables
echo ----------------------------------
echo Setting Java and Gradle environment variables to fix SSL issues...
set JAVA_OPTS=-Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=Windows-ROOT -Djavax.net.ssl.trustStorePassword=
set GRADLE_OPTS=-Dorg.gradle.internal.http.connectionTimeout=120000 -Dorg.gradle.internal.http.socketTimeout=120000 -Dorg.gradle.internal.repository.max.retries=5 -Dorg.gradle.internal.repository.timeout=30000
echo Environment variables set successfully!
echo.
echo Step 3: Cleaning Project
echo -------------------
echo Cleaning Flutter project...
flutter clean
echo.
echo Getting dependencies...
flutter pub get
echo.
echo Step 4: Running App
echo --------------
echo Now attempting to run your app...
echo If this still fails, please try:
echo 1. Running this script as Administrator
echo 2. Restarting your computer after enabling Developer Mode
echo 3. Checking your firewall/antivirus settings
echo.
flutter run
echo.
echo Script completed.
pause