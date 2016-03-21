:: Test if extensions can be enabled
@VERIFY OTHER 2>nul
@SETLOCAL EnableExtensions
@IF ERRORLEVEL 1 goto error_onLaunch
@ENDLOCAL
goto canSetup
:error_onLaunch
@echo Error: Unable to enable extensions.
@pause
@exit /b
:canSetup
:: Beginning of launcher code
@SETLOCAL EnableExtensions DisableDelayedExpansion
@echo off
:: Launcher
:setup
:: CONSTANTS
set VERSION=1.0.9
set BUILD=10
set QUESTION_COUNT=3
set SAVE_FILE_NAME=.save
:: END CONSTANTS
if "%~1"=="--?" goto usage
goto boot
:usage
echo CMDQuiz Version %VERSION% (build %BUILD%)
echo A quiz game being made in native Batch script.
echo Usage: %0 [options]
echo Key:
echo  options - Options for current session
echo            These options include:
echo            --skipUpdateCheck - Skip update checking
echo            --disableSaving   - Disable saving ^& loading
exit /b
:boot
echo.%* | findstr /C:"--skipUpdateCheck" 1>nul
if errorlevel 1 (goto setup_dontSkipUpdateCheck)
set SKIP_UPDATE_CHECK=0
:setup_dontSkipUpdateCheck
echo.%* | findstr /C:"--disableSaving" 1>nul
if errorlevel 1 (goto setup_dontDisableSaving)
set DISABLE_SAVING=0
:setup_dontDisableSaving
cls
set COLOR_VALUE=9F
call data\util.bat gameLoad %SAVE_FILE_NAME%
color %COLOR_VALUE%
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
ENDLOCAL
exit /b
