:: Test if extensions can be enabled
@VERIFY OTHER 2>nul
@SETLOCAL EnableExtensions
@IF ERRORLEVEL 1 goto error_onLaunch
@ENDLOCAL
@goto canSetup
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
set USER_DIR="%localappdata%\CMDQuiz"
if not exist %USER_DIR% md %USER_DIR%
pause
set TEMP_DIR=%~dp0
if defined temp (set TEMP_DIR=%temp%) else if defined tmp (set TEMP_DIR=%tmp%)
set GAME_NAME=CMDQuiz
set VERSION=1.1.7
set BUILD=20
set QUESTION_COUNT=3
set SAVE_FILE_NAME="%USER_DIR%\%GAME_NAME%.save"
set SAVE_FILE_VERSION=1
set LOCK_FILE_NAME="%TEMP_DIR%\%GAME_NAME%.SessionLock"
set CHANGELOG_FILE_NAME=Changelog.txt
set CONNECTION_TEST_SERVER=www.google.com
if not exist %LOCK_FILE_NAME% goto setup_noLock
echo Error: Session is already running.
pause
goto exitBat
:setup_noLock
copy nul %LOCK_FILE_NAME%>nul
attrib %LOCK_FILE_NAME% +H
:: END CONSTANTS
if "%~1"=="--?" goto usage
goto boot
:usage
echo CMDQuiz Version %VERSION% (build %BUILD%)
echo A quiz game being made in native Batch script.
echo Usage: %~n0 [options]
echo Key:
echo     options - Options for current session
echo               These options include:
echo               --skipUpdateCheck - Skip update checking
echo               --disableSaving   - Disable saving ^& loading
exit /b
:boot
echo.%* | findstr /ic:"--skipUpdateCheck">nul
if %errorlevel% equ 0 set SKIP_UPDATE_CHECK=true
echo.%* | findstr /ic:"--disableSaving">nul
if %errorlevel% equ 0 set DISABLE_SAVING=true
cls
pushd %~dp0
set COLOR_VALUE=9F
call data\util.bat gameLoad %SAVE_FILE_NAME% g
set "g="
color %COLOR_VALUE%
title CMDQuiz Version %VERSION% (build %BUILD%)
ping "%CONNECTION_TEST_SERVER%" -n 1 -w 1000>nul
if errorlevel 1 (
  echo Error: Can't check for updates, not connected to the internet.
  pause
  goto launch
)
if defined SKIP_UPDATE_CHECK goto launch
:checkForUpdates
if exist version.txt del version.txt
bitsadmin /transfer checkForUpdates /download /priority normal "https://www.dropbox.com/s/lhtvg70xfxfh0lj/version.txt?dl=1" "%CD%\version.txt" >nul
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
:endGame
attrib %LOCK_FILE_NAME% -H
if exist %LOCK_FILE_NAME% del %LOCK_FILE_NAME%
popd
:exitBat
ENDLOCAL
exit /b
