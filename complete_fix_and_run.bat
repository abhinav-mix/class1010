@echo off
echo Complete Fix and Run Script
echo ==========================
echo.

echo 1. Cleaning Gradle Cache...
cd android
gradlew --stop
cd ..
rd /s /q "%USERPROFILE%\.gradle\caches" 2>nul

echo.
echo 2. Cleaning Flutter build...
flutter clean

echo.
echo 3. Getting fresh dependencies...
flutter pub get

echo.
echo 4. Adding SSL fixes to gradle.properties...
echo. >> android/gradle.properties
echo # SSL Fix Properties >> android/gradle.properties
echo org.gradle.internal.http.connectionTimeout=120000 >> android/gradle.properties
echo org.gradle.internal.http.socketTimeout=120000 >> android/gradle.properties
echo org.gradle.internal.repository.max.retries=5 >> android/gradle.properties
echo org.gradle.internal.repository.timeout=30000 >> android/gradle.properties
echo systemProp.https.protocols=TLSv1.2,TLSv1.3 >> android/gradle.properties
echo systemProp.javax.net.ssl.trustStore=NONE >> android/gradle.properties

echo.
echo 5. Running the app...
flutter run

echo.
echo Script completed!
pause