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
set TEMP_DIR=%~dp0
if defined temp (set TEMP_DIR=%temp%) else if defined tmp (set TEMP_DIR=%tmp%)
set GAME_NAME=CMDQuiz
set VERSION=1.1.9_2
set BUILD=25
set QUESTION_COUNT=3
set SAVE_FILE_NAME="%USER_DIR%\%GAME_NAME%.save"
set SAVE_FILE_VERSION=2
set SETTINGS_FILE_NAME="%USER_DIR%\%GAME_NAME%.settings"
set SETTINGS_FILE_VERSION=1
set CHANGELOG_FILE_NAME=Changelog.txt
set CONNECTION_TEST_SERVER=www.google.com
set DEFAULT_COLOR_VALUE=9F
:: END CONSTANTS
echo.%* | findstr /ic:"--?">nul
if %errorlevel% equ 0 goto usage
echo.%* | findstr /ic:"--skip-update-check">nul
if %errorlevel% equ 0 set SKIP_UPDATE_CHECK=1
echo.%* | findstr /ic:"--disable-saving">nul
if %errorlevel% equ 0 set DISABLE_SAVING=1
goto boot
:usage
echo CMDQuiz Version %VERSION% (build %BUILD%)
echo A quiz game being made in native Batch script.
echo Usage: %~n0 [options]
echo Key:
echo     options - Options for current session.
echo               These options include:
echo               --?                 - Shows this help message.
echo               --skip-update-check - Skips update checking.
echo               --disable-saving    - Disables saving and loading
echo                                     (does NOT affect settings file).
endlocal
exit /b
:boot
cls
pushd %~dp0
set COLOR_VALUE=%DEFAULT_COLOR_VALUE%
call data\util.bat settingsLoad %SETTINGS_FILE_NAME% g
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
popd
ENDLOCAL
exit /b
