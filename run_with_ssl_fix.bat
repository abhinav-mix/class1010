@echo off
echo Running App with SSL Fixes...
echo.

echo Setting SSL environment variables...
set JAVA_OPTS=-Djavax.net.ssl.trustStore=NUL -Djavax.net.ssl.trustStoreType=JKS
set GRADLE_OPTS=-Dorg.gradle.internal.http.connectionTimeout=120000 -Dorg.gradle.internal.http.socketTimeout=120000 -Dorg.gradle.internal.repository.max.retries=5 -Dorg.gradle.internal.repository.timeout=30000

echo.
echo Running Flutter with SSL fixes...
flutter run

echo.
echo If you still encounter issues, try running 'complete_fix_and_run.bat'
pause