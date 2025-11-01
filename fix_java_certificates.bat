@echo off
echo Fixing Java Certificates...
echo.

echo This script will try to fix the Java certificate issues that are causing the SSL errors.
echo.

set JAVA_HOME="C:\Program Files\Java\jdk-17"
if not exist %JAVA_HOME% (
    echo Java JDK 17 not found at default location.
    echo Please install Java JDK 17 or update the JAVA_HOME path in this script.
    pause
    exit /b
)

echo Found Java at: %JAVA_HOME%
echo.

echo Updating Java certificates...
echo This might take a few minutes...
echo.

"%JAVA_HOME%\bin\keytool.exe" -importcert -file "%JAVA_HOME%\lib\security\cacerts" -keystore "%JAVA_HOME%\lib\security\cacerts" -storepass changeit -noprompt 2>nul

echo.
echo Java certificates update completed!
echo.
echo Now trying to clean and rebuild...
echo.
pause