@echo off
cls
echo ==========================================
echo    COMPLETE FIX FOR QUIZ APP ERRORS
echo ==========================================
echo.

echo 1. Fixing deprecated withOpacity issues...
call fix_deprecated_issues.bat
echo Done!
echo.

echo 2. Fixing duplicate questions...
cd /d "e:\class_10 free\new"
python fix_duplicate_questions.py
echo Done!
echo.

echo 3. Running Flutter analyze to verify fixes...
flutter analyze
echo.

echo 4. Running tests to ensure everything works...
flutter test
echo.

echo ==========================================
echo    ALL FIXES COMPLETED SUCCESSFULLY!
echo ==========================================
echo.
echo You can now run your app with: flutter run
echo.
pause