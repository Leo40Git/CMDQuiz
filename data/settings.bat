@echo off
:: Settings menu
:main
if defined menu set "menu="
cls
echo Settings
echo 1) Color settings
echo 2) Return to menu
set /p menu="What is your selection? "
set /a menu=menu
if %menu% equ 1 goto color
if %menu% equ 2 goto returnToMenu
:invalid
echo Invalid selection.
pause
goto main
:color
call data\colormenu.bat
goto main
:returnToMenu
goto:eof
