@echo off
echo Comprehensive Fix for Flutter Build Issues
echo ========================================
echo.

echo 1. Enabling Developer Mode...
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -Name 'AllowDevelopmentWithoutDevLicense' -Value 1" 2>nul
if %errorlevel% equ 0 (
    echo    Developer Mode enabled successfully!
) else (
    echo    Note: Run this script as Administrator to enable Developer Mode
)

echo.
echo 2. Cleaning Gradle and Flutter cache...
cd android
gradlew --stop 2>nul
cd ..
rd /s /q "%USERPROFILE%\.gradle\caches" 2>nul
flutter clean

echo.
echo 3. Updating gradle.properties with SSL fixes...
echo. >> android/gradle.properties
echo # Comprehensive SSL Fixes >> android/gradle.properties
echo org.gradle.internal.http.connectionTimeout=120000 >> android/gradle.properties
echo org.gradle.internal.http.socketTimeout=120000 >> android/gradle.properties
echo org.gradle.internal.repository.max.retries=5 >> android/gradle.properties
echo org.gradle.internal.repository.timeout=30000 >> android/gradle.properties
echo systemProp.https.protocols=TLSv1.2,TLSv1.3 >> android/gradle.properties
echo systemProp.javax.net.ssl.trustStore=NUL >> android/gradle.properties
echo systemProp.javax.net.ssl.trustStoreType=JKS >> android/gradle.properties
echo systemProp.javax.net.ssl.trustStorePassword=changeit >> android/gradle.properties
echo systemProp.jsse.enableSNIExtension=true >> android/gradle.properties

echo.
echo 4. Setting environment variables...
set JAVA_OPTS=-Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.trustStorePassword=changeit
set GRADLE_OPTS=-Dorg.gradle.internal.http.connectionTimeout=120000 -Dorg.gradle.internal.http.socketTimeout=120000 -Dorg.gradle.internal.repository.max.retries=5 -Dorg.gradle.internal.repository.timeout=30000

echo.
echo 5. Getting dependencies...
flutter pub get

echo.
echo 6. Running the app...
echo If this still fails, please run this script as Administrator
flutter run

echo.
echo Fix process completed!
pause