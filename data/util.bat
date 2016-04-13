@echo off
:: Utilities
:launchUtil
if "%1"=="" goto exitUtil
call :%1 %2 %3
:exitUtil
exit /b
:: Get string length
:strlen string resultVar
setlocal EnableDelayedExpansion
set str=%1
:strlen_loop
if not "!str:~%len%!"=="" set /A len+=1 & goto strlen_loop
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
:: Check if valid answer
:isAnswer string resultVar
SET "var="&for /f "delims=ABCDabcd" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
goto exitUtil
:: Create a save file to load with gameLoad
:gameSave fileName
if defined DISABLE_SAVING goto exitUtil
set curlvl=1
if defined CURRENT_LEVEL set curlvl=%CURRENT_LEVEL%
(
  echo CMDQUIZ_SAVE_V%SAVE_FILE_VERSION%
  echo %BUILD%
  echo %curlvl%
  echo %COLOR_VALUE%
) > %1
goto exitUtil
:: Load a save file made with gameSave
:gameLoad fileName successVar
if defined DISABLE_SAVING goto exitUtil
if not exist %1 goto exitUtil
< %1 (
  set /p savever=
  )
if "%savever%" NEQ "CMDQUIZ_SAVE_V%SAVE_FILE_VERSION%" goto gameLoad_invalid
< %1 (
  set /p savever=
  set /p savebuild=
  )
if %savebuild% GTR %BUILD% goto gameLoad_invalid
< %1 (
  set /p savever=
  set /p savebuild=
  set /p cur_lvl=
  )
if %cur_lvl% LSS 1 goto gameLoad_invalid
if %cur_lvl% GTR %QUESTION_COUNT% goto gameLoad_invalid
< %1 (
  set /p savever=
  set /p savebuild=
  set /p cur_lvl=
  set /p col_val=
  )
if %col_val:~0%==%col_val:~1% goto gameLoad_invalid
setlocal
set hex=0
call :isHex %col_val% hex
if %hex% equ 0 goto gameLoad_invalid
endlocal
set CURRENT_LEVEL=%cur_lvl%
set COLOR_VALUE=%col_val%
set %2=1
goto gameLoad_exit
:gameLoad_invalid
set %2=0
:gameLoad_exit
if defined savever set "savever="
if defined savebuild set "savebuild="
if defined cur_lvl set "cur_lvl="
if defined col_val set "col_val="
goto exitUtil
