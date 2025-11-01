@echo off
echo Fixing deprecated withOpacity issues in Flutter project...

cd /d "e:\class_10 free\new"

echo Backing up original files...
xcopy lib\*.dart backup\ /s /e /y >nul 2>&1
if not exist backup mkdir backup
xcopy lib\*.dart backup\ /s /e /y >nul

echo Fixing withOpacity deprecation issues...

powershell -Command "(Get-Content 'lib\screens\home_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\home_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\quiz_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\quiz_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\result_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\result_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\saved_questions_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\saved_questions_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\leaderboard_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\leaderboard_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\about_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\about_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\profile_edit_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\profile_edit_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\profile_setup_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\profile_setup_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\progress_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\progress_screen.dart'"
powershell -Command "(Get-Content 'lib\screens\level_selection_screen.dart') -replace 'withOpacity\((0\.\d+)\)', 'withValues(alpha: $1)' | Set-Content 'lib\screens\level_selection_screen.dart'"

echo Removing unused timezone import from notification_service.dart...
powershell -Command "(Get-Content 'lib\services\notification_service.dart') -replace 'import \\'package:timezone/timezone.dart\\';', '' | Set-Content 'lib\services\notification_service.dart'"

echo Fixing constant naming issues...
powershell -Command "(Get-Content 'lib\services\smartlink_service.dart') -replace '_SMARTLINK_URL', 'smartlinkUrl' | Set-Content 'lib\services\smartlink_service.dart'"
powershell -Command "(Get-Content 'lib\services\smartlink_service.dart') -replace '_CLICK_COUNT_KEY', 'clickCountKey' | Set-Content 'lib\services\smartlink_service.dart'"

echo Running Flutter pub get to update dependencies...
flutter pub get

echo All deprecated issues have been fixed!
echo Running flutter analyze to verify fixes...
flutter analyze

pause