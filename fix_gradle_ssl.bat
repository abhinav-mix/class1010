@echo off
echo Fixing Gradle SSL Issues...
echo.

echo Adding system properties to gradle.properties...
echo org.gradle.internal.http.connectionTimeout=120000 >> android/gradle.properties
echo org.gradle.internal.http.socketTimeout=120000 >> android/gradle.properties
echo org.gradle.internal.repository.max.retries=5 >> android/gradle.properties
echo org.gradle.internal.repository.timeout=30000 >> android/gradle.properties
echo systemProp.https.protocols=TLSv1.2,TLSv1.3 >> android/gradle.properties
echo systemProp.javax.net.ssl.trustStore=NONE >> android/gradle.properties

echo.
echo Gradle SSL properties added successfully!
echo.
echo Now trying to clean and rebuild...
echo.
pause