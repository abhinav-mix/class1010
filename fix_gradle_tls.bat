@echo off
cls
echo ==========================================
echo    FIXING GRADLE TLS ISSUES
echo ==========================================
echo.

echo Backing up original gradle.properties...
copy "android\gradle.properties" "android\gradle.properties.bak" >nul

echo Fixing gradle.properties for TLS compatibility...
powershell -Command "(Get-Content 'android\gradle.properties') -replace 'systemProp.https.protocols=TLSv1.2,TLSv1.3', '' | Set-Content 'android\gradle.properties'"
powershell -Command "(Get-Content 'android\gradle.properties') -replace 'systemProp.javax.net.ssl.trustStore=NONE', '' | Set-Content 'android\gradle.properties'"
powershell -Command "(Get-Content 'android\gradle.properties') -replace 'systemProp.javax.net.ssl.trustStoreType=JKS', '' | Set-Content 'android\gradle.properties'"
powershell -Command "(Get-Content 'android\gradle.properties') -replace 'systemProp.javax.net.ssl.trustStorePassword=changeit', '' | Set-Content 'android\gradle.properties'"

echo Adding proper TLS configuration...
echo. >> "android\gradle.properties"
echo # TLS Configuration for Gradle >> "android\gradle.properties"
echo org.gradle.jvmargs=-Dhttps.protocols=TLSv1.2 -Djavax.net.ssl.trustStoreType=Windows-ROOT >> "android\gradle.properties"

echo Cleaning Gradle cache...
cd android
if exist ".gradle" rmdir /s /q ".gradle" >nul 2>&1
cd ..

echo.
echo Gradle TLS fix completed!
echo You can now try running the app again with: flutter run
echo.

pause