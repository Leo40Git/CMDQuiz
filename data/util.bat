@echo off
:: Utilities
:launchUtil
if [%1]==[] goto exitUtil
if %1 == strlen call :strlen %2 %3
if %1 == delay call :delay %2
if %1 == isNum call :isNum %2 %3
if %1 == isHex call :isHex %2 %3
:exitUtil
goto:eof
:: Get string length
:strlen
setlocal EnableDelayedExpansion
:strlen_loop
if not "!%1:~%len%!"=="" set /A len+=1 & goto strlen_loop
(endlocal & set %2=%len%)
goto exitUtil
:: Delay execution
:delay
setlocal
set /a "delay=%1+1"
ping -n %delay% 127.0.0.1>nul
endlocal
goto exitUtil
:: Check if number
:isNum
setlocal
SET "var="&for /f "delims=0123456789" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
endlocal
goto exitUtil
:: Check if hexadecimal value
:isHex
setlocal
SET "var="&for /f "delims=0123456789ABCDEF" %%i in ("%1") do set var=%%i
if defined var (set %2=0) else (set %2=1)
endlocal
goto exitUtil