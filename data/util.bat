@echo off
:: Utilities
:launchUtil
if "%1"=="" goto exitUtil
if /i %1 == strlen call :strlen %2 %3
if /i %1 == delay call :delay %2
if /i %1 == isNum call :isNum %2 %3
if /i %1 == isHex call :isHex %2 %3
if /i %1 == gameSave call :gameSave %2
if /i %1 == gameLoad call :gameLoad %2
:exitUtil
goto:eof
:: Get string length
:strlen string resultVar
setlocal EnableDelayedExpansion
:strlen_loop
if not "!%1:~%len%!"=="" set /A len+=1 & goto strlen_loop
(endlocal & set %2=%len%)
goto exitUtil
:: Delay execution
:delay seconds
setlocal
set /a "delay=%1+1"
ping -n %delay% 127.0.0.1>nul
endlocal
goto exitUtil
:: Check if number
:isNum string resultVar
SET "var="&for /f "delims=0123456789" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
goto exitUtil
:: Check if hexadecimal value
:isHex string resultVar
SET "var="&for /f "delims=0123456789ABCDEFabcdef" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
goto exitUtil
:: Create a save file to load with gameLoad
:gameSave fileName
if defined DISABLE_SAVING goto exitUtil
(
  echo CMDQUIZ_%BUILD%_SAVE
  echo %CURRENT_LEVEL%
  echo %COLOR_VALUE%
) > %1
goto exitUtil
:: Load a save file made with gameSave
:gameLoad fileName
if defined DISABLE_SAVING goto exitUtil
if not exist %1 goto exitUtil
< %1 (
  set /p SAVE_VERSION=
  )
if "%SAVE_VERSION%" NEQ "CMDQUIZ_%BUILD%_SAVE" goto gameLoad_invalid
< %1 (
  set /p SAVE_VERSION=
  set /p CURRENT_LEVEL=
  set /p COLOR_VALUE=
  )
:gameLoad_invalid
if defined SAVE_VERSION set "SAVE_VERSION="
goto exitUtil
