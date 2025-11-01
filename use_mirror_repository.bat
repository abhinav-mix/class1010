@echo off
echo Using Mirror Repository
echo =====================
echo.

echo Adding mirror repository to gradle.properties...
echo. >> android/gradle.properties
echo # Mirror Repository Configuration >> android/gradle.properties
echo systemProp.http.proxyHost= >> android/gradle.properties
echo systemProp.http.proxyPort= >> android/gradle.properties
echo systemProp.https.proxyHost= >> android/gradle.properties
echo systemProp.https.proxyPort= >> android/gradle.properties
echo # Using Aliyun mirror for Google repositories >> android/gradle.properties
echo # Uncomment the following lines if you're in China or having connection issues >> android/gradle.properties
echo # google().mavenContent { >> android/gradle.properties
echo #     url "https://maven.aliyun.com/repository/google" >> android/gradle.properties
echo # } >> android/gradle.properties

echo.
echo Mirror configuration added to gradle.properties
echo.
echo Cleaning and rebuilding...
echo.

flutter clean
flutter pub get

echo.
echo You can now try running your app:
echo flutter run
echo.
echo If you're in China, uncomment the mirror lines in android/build.gradle.kts
pause