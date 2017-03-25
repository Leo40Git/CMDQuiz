@echo off
:: Utilities
:launchUtil
if "%1"=="" goto:eof
call :%*
goto:eof

:: Get string length
:strlen string resultVar
setlocal EnableDelayedExpansion
set "s=%~1#"
set "len=0"
for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
	if "!s:~%%P,1!" NEQ "" set /a "len+=%%P"&&set "s=!s:~%%P!"
)
(endlocal && set "%~2=%len%")
goto:eof

:: Delay execution
:delay seconds
setlocal
set /a "delay=%1+1"
ping -n %delay% 127.0.0.1>nul
endlocal
goto:eof

:: Check if number
:isNum string resultVar
SET "var="&for /f "delims=0123456789" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
goto:eof

:: Check if hexadecimal value
:isHex string resultVar
SET "var="&for /f "delims=0123456789ABCDEFabcdef" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
goto:eof

:: Create a save file to load with gameLoad
:gameSave
if defined DISABLE_SAVING goto:eof
set cur_lvl=1
if defined CURRENT_LEVEL set cur_lvl=%CURRENT_LEVEL%
(
  echo CMDQUIZ_SAVE_V%SAVE_FILE_VERSION%
  echo %BUILD%
  echo %cur_lvl%
) > %SAVE_FILE_NAME%
set "cur_lvl="
goto:eof

:: Load a save file made with gameSave
:gameLoad resultVar
if defined DISABLE_SAVING goto:eof
if not exist %SAVE_FILE_NAME% goto:eof
< %SAVE_FILE_NAME% (
  set /p savever=
  )
if "%savever%" NEQ "CMDQUIZ_SAVE_V%SAVE_FILE_VERSION%" goto gameLoad_invalid
< %SAVE_FILE_NAME% (
  set /p savever=
  set /p savebuild=
  )
if %savebuild% GTR %BUILD% goto gameLoad_invalid
< %SAVE_FILE_NAME% (
  set /p savever=
  set /p savebuild=
  set /p cur_lvl=
  )
if %cur_lvl% LSS 1 goto gameLoad_invalid
if %cur_lvl% GTR %QUESTION_COUNT% goto gameLoad_invalid
set CURRENT_LEVEL=%cur_lvl%
set %1=1
goto gameLoad_exit
:gameLoad_invalid
set %1=0
:gameLoad_exit
if defined savever set "savever="
if defined savebuild set "savebuild="
if defined cur_lvl set "cur_lvl="
goto:eof

:: Sets the errorlevel
:setErrorlevel errlvl
setlocal
set /a "errlvl=%1"
cmd /c "exit /b %errlvl%"
endlocal
goto:eof

:: Gets file path
:getFilePath file resultVar
set %2=%~dp1
goto:eof

:: Create a settings file to load with settingsLoad
:settingsSave
(
  echo CMDQUIZ_SETTINGS_V%SETTINGS_FILE_VERSION%
  echo %BUILD%
  echo %COLOR_VALUE%
) > %SETTINGS_FILE_NAME%
goto:eof

:: Load a settings file made with settingsSave
:settingsLoad resultVar
if not exist %SETTINGS_FILE_NAME% goto:eof
< %SETTINGS_FILE_NAME% (
  set /p savever=
  )
if "%savever%" NEQ "CMDQUIZ_SETTINGS_V%SETTINGS_FILE_VERSION%" goto settingsLoad_invalid
< %SETTINGS_FILE_NAME% (
  set /p savever=
  set /p savebuild=
  )
if %savebuild% GTR %BUILD% goto settingsLoad_invalid
< %SETTINGS_FILE_NAME% (
  set /p savever=
  set /p savebuild=
  set /p col_val=
  )
set len=0
call :strlen %col_val% len
if %len% GTR 2 set col_val=%col_val:~0,2%
if %col_val:~0,1%==%col_val:~1,1% goto settingsLoad_invalid
set hex=0
call :isHex %col_val% hex
if %hex% equ 0 goto settingsLoad_invalid
set COLOR_VALUE=%col_val%
set %1=1
goto settingsLoad_exit
:settingsLoad_invalid
set %1=0
:settingsLoad_exit
if defined hex set "hex="
if defined len set "len="
if defined savever set "savever="
if defined savebuild set "savebuild="
if defined col_val set "col_val="
goto:eof
