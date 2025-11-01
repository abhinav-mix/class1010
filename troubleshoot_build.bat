@echo off
echo Flutter Build Troubleshooter
echo ==========================
echo.

echo 1. Checking Java version...
java -version
echo.

echo 2. Checking Flutter version...
flutter --version
echo.

echo 3. Checking Flutter doctor...
flutter doctor
echo.

echo 4. Checking environment variables...
echo JAVA_HOME=%JAVA_HOME%
echo ANDROID_HOME=%ANDROID_HOME%
echo ANDROID_SDK_ROOT=%ANDROID_SDK_ROOT%
echo.

echo 5. Checking gradle.properties...
type android\gradle.properties
echo.

echo 6. Checking if Developer Mode is enabled...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense 2>nul
if %errorlevel% equ 0 (
    echo Developer Mode is enabled.
) else (
    echo Developer Mode is NOT enabled.
    echo Please enable Developer Mode in Windows Settings.
)
echo.

echo 7. Checking network connectivity to Google...
ping -n 1 dl.google.com >nul
if %errorlevel% equ 0 (
    echo Network connectivity to Google is OK.
) else (
    echo Network connectivity to Google FAILED.
    echo This may be causing the download issues.
)
echo.

echo Troubleshooting complete.
echo.
echo Common solutions:
echo 1. Run 'comprehensive_fix.bat' as Administrator
echo 2. Run 'update_java_certificates.bat'
echo 3. Enable Developer Mode in Windows Settings
echo 4. Check your firewall/antivirus settings
echo 5. Try using a different network connection
pause