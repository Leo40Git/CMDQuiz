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
set GAME_NAME=CMDQuiz
set VERSION=1.1.1
set BUILD=12
set QUESTION_COUNT=3
set SAVE_FILE_NAME=%GAME_NAME%.save
set SAVE_FILE_VERSION=1
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
set ORIG_DIR=%CD%
cd %~dp0
set COLOR_VALUE=9F
call data\util.bat gameLoad %SAVE_FILE_NAME% nul
color %COLOR_VALUE%
title CMDQuiz Version %VERSION% (build %BUILD%)
if defined SKIP_UPDATE_CHECK goto launch
:checkForUpdates
if exist version.txt del version.txt
bitsadmin /transfer checkForUpdates /download /priority normal "https://www.dropbox.com/s/oe2k15b58i7hqny/version.txt?dl=1" "%CD%\version.txt" >nul
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
cd %ORIG_DIR%
ENDLOCAL
exit /b
