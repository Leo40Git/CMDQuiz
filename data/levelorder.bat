@echo off
:: Level order

:lvlorder
set lvlnum=%1
if [%lvlnum%] == [] goto lvl1
if %lvlnum% LSS 1 goto lvlorder_invalid
if %lvlnum% GTR %QUESTION_COUNT% goto lvlorder_invalid
set lvl=lvl%lvlnum%
goto %lvl%
:lvlorder_invalid
echo Specified level doesn't exist!
goto:eof

:: Level entry base
:: X is level number
:lvlX
set CURRENT_LEVEL=X
call data\util.bat gameSave
call data\question.bat Question "Answer 1" "Answer 2" "Answer 3" "Answer 4" 1

:lvl1
set CURRENT_LEVEL=1
call data\util.bat gameSave
call data\question.bat "What is the most popular indie game?" Minecraft "Nuclear Throne" "The Binding of Isaac" Undertale 1

:lvl2
set CURRENT_LEVEL=2
call data\util.bat gameSave
call data\question.bat "Which food doesn't fit?" "Hot Dog" "Hamburger" "Pizza" "Cake" 4

:lvl3
set CURRENT_LEVEL=3
call data\util.bat gameSave
call data\question.bat "No question... yet." "Incorrect" "Correct" "Incorrect" "Incorrect" 2

:lvlorder_end
goto:eof
