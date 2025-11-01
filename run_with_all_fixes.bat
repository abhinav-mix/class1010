@echo off
echo Running App with All Fixes
echo ========================
echo.

echo Setting comprehensive environment variables...
set JAVA_OPTS=-Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.trustStorePassword=changeit -Djsse.enableSNIExtension=true
set GRADLE_OPTS=-Dorg.gradle.internal.http.connectionTimeout=120000 -Dorg.gradle.internal.http.socketTimeout=120000 -Dorg.gradle.internal.repository.max.retries=5 -Dorg.gradle.internal.repository.timeout=30000 -Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.trustStorePassword=changeit
set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
set ANDROID_SDK_ROOT=%LOCALAPPDATA%\Android\Sdk

echo.
echo Environment variables set:
echo JAVA_OPTS=%JAVA_OPTS%
echo GRADLE_OPTS=%GRADLE_OPTS%
echo ANDROID_HOME=%ANDROID_HOME%

echo.
echo Cleaning build...
flutter clean

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Running app with fixes...
flutter run

echo.
echo If this still fails, try running 'comprehensive_fix.bat' as Administrator
pause