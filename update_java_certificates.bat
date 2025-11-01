@echo off
echo Updating Java Certificates
echo ========================
echo.

echo This script will update Java certificates which should fix SSL issues.
echo.

echo Finding Java installation...
for /f "tokens=*" %%i in ('where java') do set JAVA_PATH=%%i
if "%JAVA_PATH%"=="" (
    echo Java not found in PATH. Trying default locations...
    if exist "C:\Program Files\Java\jdk-17\bin\java.exe" (
        set JAVA_HOME=C:\Program Files\Java\jdk-17
    ) else if exist "C:\Program Files\Java\jdk-11\bin\java.exe" (
        set JAVA_HOME=C:\Program Files\Java\jdk-11
    ) else if exist "C:\Program Files\Java\jdk-8\bin\java.exe" (
        set JAVA_HOME=C:\Program Files\Java\jdk-8
    ) else (
        echo Java installation not found. Please install Java JDK.
        pause
        exit /b
    )
) else (
    echo Java found at: %JAVA_PATH%
    for %%i in ("%JAVA_PATH%") do set JAVA_HOME=%%~dpi
    set JAVA_HOME=%JAVA_HOME:~0,-5%
)

echo.
echo Java Home: %JAVA_HOME%
echo.

if not exist "%JAVA_HOME%" (
    echo Java home directory not found.
    pause
    exit /b
)

echo Backing up existing cacerts...
if exist "%JAVA_HOME%\lib\security\cacerts.bak" (
    echo Backup already exists.
) else (
    copy "%JAVA_HOME%\lib\security\cacerts" "%JAVA_HOME%\lib\security\cacerts.bak"
    if %errorlevel% equ 0 (
        echo Backup created successfully.
    ) else (
        echo Failed to create backup. Continuing anyway...
    )
)

echo.
echo Updating certificates...
echo This may take several minutes...
echo.

"%JAVA_HOME%\bin\keytool.exe" -importcert -noprompt -file "%JAVA_HOME%\lib\security\cacerts" -keystore "%JAVA_HOME%\lib\security\cacerts" -storepass changeit 2>nul

echo.
echo Certificate update completed!
echo.
echo Now cleaning and rebuilding...
echo.

cd android
gradlew --stop 2>nul
cd ..

flutter clean
flutter pub get

echo.
echo You can now try running your app:
echo flutter run
pause