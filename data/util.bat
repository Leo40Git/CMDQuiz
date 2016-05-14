@echo off
:: Utilities
:launchUtil
if "%1"=="" goto exitUtil
call :%*
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

:: Create a save file to load with gameLoad
:gameSave fileName
if defined DISABLE_SAVING goto exitUtil
set cur_lvl=1
if defined CURRENT_LEVEL set cur_lvl=%CURRENT_LEVEL%
(
  echo CMDQUIZ_SAVE_V%SAVE_FILE_VERSION%
  echo %BUILD%
  echo %cur_lvl%
  echo %COLOR_VALUE%
) > %1
set "cur_lvl="
goto exitUtil

:: Load a save file made with gameSave
:gameLoad fileName resultVar
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
set len=0
call :strlen %col_val% len
if %len% GTR 2 set col_val=%col_val:~0,2%
if %col_val:~0,1%==%col_val:~1,1% goto gameLoad_invalid
set hex=0
call :isHex %col_val% hex
if %hex% equ 0 goto gameLoad_invalid
set CURRENT_LEVEL=%cur_lvl%
set COLOR_VALUE=%col_val%
set %2=1
goto gameLoad_exit
:gameLoad_invalid
set %2=0
:gameLoad_exit
if defined hex set "hex="
if defined len set "len="
if defined savever set "savever="
if defined savebuild set "savebuild="
if defined cur_lvl set "cur_lvl="
if defined col_val set "col_val="
goto exitUtil

:: Sets the errorlevel
:setErrorlevel errlvl
setlocal
set errlvl=%1
set /a "errlvl=%errlvl%"
set command="exit /b %errlvl%"
cmd /c %command%
endlocal
goto exitUtil

:: Gets file path
:getFilePath file resultVar
set %2=%~dp1
goto exitUtil
