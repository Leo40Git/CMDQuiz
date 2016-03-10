@echo off
:: Launcher
:setup
:: CONSTANTS
set VERSION=1.0.6
set BUILD=7
set QUESTION_COUNT=2
set SAVE_FILE_NAME=.save
:: END CONSTANTS
if not exist .skipUpdateCheck goto setup_dontSkipUpdateCheck
set SKIP_UPDATE_CHECK=0
:setup_dontSkipUpdateCheck
if not exist .disableSaving goto setup_dontDisableSaving
set DISABLE_SAVING=0
:setup_dontDisableSaving
cls
set col=9F
color %col%
title CMDQuiz Version %VERSION% (build %BUILD%)
if defined SKIP_UPDATE_CHECK goto launch
:checkForUpdates
if exist version.txt del version.txt
bitsadmin /transfer checkForUpdates /download /priority normal "https://www.dropbox.com/s/oe2k15b58i7hqny/version.txt?dl=1" "%CD%\version.txt">nul
set /p newBuild=<version.txt
if exist version.txt del version.txt
if %BUILD% LSS %newBuild% goto update_newVersion
if %BUILD% GEQ %newBuild% goto update_upToDate
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
