@echo off
:: Question screen
:: Parameters:
:: 1 - question
:: 2-5 - answers
:: 6 - correct answer
:question
cls
if [%answer%]==[] goto skipReset
set "answer="
:skipReset
echo %~1
echo A) %~2
echo B) %~3
echo C) %~4
echo D) %~5
set /p answer="What is your answer? "
if [%answer%]==[] goto incorrect
if /i %answer% == %6 goto correct
:incorrect
echo The answer is incorrect.
pause
goto question
:correct
echo The answer is correct!
pause
goto:eof