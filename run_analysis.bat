@echo off
echo Quiz App Analysis Tool
echo =====================
echo.
echo This tool will analyze the quiz app for duplicate questions.
echo.
echo Press any key to continue...
pause >nul
echo.
echo Running duplicate analysis...
echo.
python safe_fix_duplicates.py
echo.
echo Analysis complete!
echo.
echo Please check the following files:
echo  - duplicate_fix_guide.md (Detailed duplicate report)
echo  - solution_summary.md (Summary of issues and solutions)
echo.
echo Press any key to exit...
pause >nul