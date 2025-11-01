@echo off
echo Quick Fix and Run
echo ================
echo.

echo Setting Java SSL properties...
set JAVA_OPTS=-Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=Windows-ROOT
set GRADLE_OPTS=-Dorg.gradle.internal.http.connectionTimeout=120000 -Dorg.gradle.internal.http.socketTimeout=120000

echo.
echo JAVA_OPTS=%JAVA_OPTS%
echo GRADLE_OPTS=%GRADLE_OPTS%
echo.

echo Cleaning and rebuilding...
flutter clean
flutter pub get

echo.
echo Running app...
flutter run

echo.
echo If this fails, please try running as Administrator
pause