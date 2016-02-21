@echo off
:: Launcher
:setup
cls
set col=9F
color %col%
set version=1.0.0
set build=1
title CMDQuiz Version %version% (build %build%)
:checkForUpdates
if exist version.txt del version.txt
bitsadmin /transfer checkForUpdates /download /priority normal https://www.dropbox.com/s/oe2k15b58i7hqny/version.txt?dl=1 %CD%\version.txt
set /p newBuild=<version.txt
if %build% LSS %newBuild% goto update_newVersion
if %build% GEQ %newBuild% goto update_upToDate
:update_newVersion
echo A new version (build %newBuild%) is avalible.
echo Download it here: DL LINK GOES HERE
pause
goto launch
:update_upToDate
echo You are up to date!
pause
goto launch
:launch
if exist version.txt del version.txt
call data\menu.bat
if exist quit.txt goto endGame
:error_crash
echo Error: The game encountered an unknown error and crashed.
pause
:endGame
if exist quit.txt del quit.txt
exit /b