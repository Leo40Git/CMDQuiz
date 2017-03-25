@echo off
:: Color menu
:main
if defined menu set "menu="
cls
echo Color Settings
echo The current color is %COLOR_VALUE%.
echo 1) Change color
echo 2) Restore default color
echo 3) Return to menu
set /p menu="What is your selection? "
set /a menu=menu
if %menu% equ 1 goto changeCol
if %menu% equ 2 goto resetCol
if %menu% equ 3 goto returnToMenu
:invalid
echo Error: Invalid selection.
pause
goto main
:changeCol
echo Color values:
echo 0 = Black  ^| 8 = Gray
echo 1 = Blue   ^| 9 = Light Blue
echo 2 = Green  ^| A = Light Green
echo 3 = Aqua   ^| B = Light Aqua
echo 4 = Red    ^| C = Light Red
echo 5 = Purple ^| D = Light Purple
echo 6 = Yellow ^| E = Light Yellow
echo 7 = White  ^| F = Bright White
if not [^%col1%] == [] set "col1="
set /p col1="Enter background color: "
if [^%col1%] == [] goto error_notHex
setlocal
set collen=0
call data\util.bat strlen ^%col1% collen
if %collen% GTR 1 goto error_tooLong
set hex=0
call data\util.bat isHex ^%col1% hex
if %hex% EQU 0 goto error_notHex
endlocal
if not [^%col2%] == [] set "col2="
set /p col2="Enter foreground color: "
if [^%col2%] == [] goto error_notHex
setlocal
set collen=0
call data\util.bat strlen ^%col2% collen
if %collen% GTR 1 goto error_tooLong
set hex=0
call data\util.bat isHex ^%col2% hex
if %hex% EQU 0 goto error_notHex
endlocal
if "^%col1%"=="^%col2%" goto error_sameCol
set COLOR_VALUE=^%col1%^%col2%
color %COLOR_VALUE%
goto main
:error_tooLong
echo Error: Please type one character for each color.
pause
goto main
:error_sameCol
echo Error: Background and foreground colors cannot be the same.
pause
goto main
:error_notHex
echo Error: Please type hexadecimal values (0-9 and A-F) only.
pause
goto main
:resetCol
echo Are you sure you want to reset the color?
if not "^%rcol%" == [] set "rcol="
set /p rcol="[Y/N] "
if /i ^%rcol% == Y (goto resetColFunc) else (goto main)
:resetColFunc
set COLOR_VALUE=%DEFAULT_COLOR_VALUE%
color %COLOR_VALUE%
goto main
:returnToMenu
call data\util.bat settingsSave
goto:eof
