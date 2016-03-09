@echo off
:: Launcher
:setup
cls
:: CONSTANTS
set QUESTION_COUNT=2
set SAVE_FILE_NAME=.save
:: END CONSTANTS
set col=9F
color %col%
set version=1.0.5
set build=6
title CMDQuiz Version %version% (build %build%)
if exist .skipUpdateCheck goto launch
:checkForUpdates
if exist version.txt del version.txt
bitsadmin /transfer checkForUpdates /download /priority normal "https://www.dropbox.com/s/oe2k15b58i7hqny/version.txt?dl=1" "%CD%\version.txt">nul
set /p newBuild=<version.txt
if exist version.txt del version.txt
if %build% LSS %newBuild% goto update_newVersion
if %build% GEQ %newBuild% goto update_upToDate
:update_newVersion
echo A new version (build %newBuild%) is avalible.
echo Download it from here: https://github.com/Leo40Git/CMDQuiz
pause
goto launch
:update_upToDate
echo You are up to date!
pause
goto launch
:launch
call data\menu.bat
if exist quit.txt goto endGame
:error_crash
echo Error: The game encountered an unknown error and crashed.
pause
:endGame
if exist quit.txt del quit.txt
exit /b
