@echo off
:: Level order
:lvlorder
set lvlnum=%1
if "%lvlnum%"=="" goto lvl1
if %lvlnum% GTR %QUESTION_COUNT% goto lvl1
set lvl=lvl%lvlnum%
goto %lvl%
:lvl1
set CURRENT_LEVEL=1
call data\question.bat "What is the most popular indie game?" Minecraft "Nuclear Throne" "The Binding of Isaac" Undertale A
call data\util.bat gameSave %SAVE_FILE_NAME%
:lvl2
set CURRENT_LEVEL=2
call data\question.bat "test" "1" "2" "3" "4" A
call data\util.bat gameSave %SAVE_FILE_NAME%
:lvlorder_end
goto:eof
