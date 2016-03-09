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
if /i %1 == readIni call :readIni %2 %3 %4 %5
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
setlocal
SET "var="&for /f "delims=0123456789" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
endlocal
goto exitUtil
:: Check if hexadecimal value
:isHex string resultVar
setlocal
SET "var="&for /f "delims=0123456789ABCDEFabcdef" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
endlocal
goto exitUtil
:: Create a save file to load with gameLoad
:gameSave fileName
if exist .disableSave
(
  echo %currentLevel%
) > %1
goto exitUtil
:: Load a save file made with gameSave
:gameLoad fileName
< %1 (
  set /p currentLevel=
)
goto exitUtil
:: Read data from INI file
:readIni file area key resultVar
@setlocal enableextensions enabledelayedexpansion
@echo off
set file=%~1
set area=[%~2]
set key=%~3
set currarea=
for /f "usebackq delims=" %%a in ("!file!") do (
    set ln=%%a
    if "x!ln:~0,1!"=="x[" (
        set currarea=!ln!
    ) else (
        for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
            set currkey=%%b
            set currval=%%c
            if "x!area!"=="x!currarea!" if "x!key!"=="x!currkey!" (
                set %4=!currval!
            )
        )
    )
)
endlocal
goto exitUtil
