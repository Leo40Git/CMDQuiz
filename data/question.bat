@echo off
:: Question screen
:: Parameters:
:: 1 - question
:: 2-5 - answers
:: 6 - correct answer
:question question answerA answerB answerC answerD correctAnswer
setlocal
cls
setlocal
set valid=0
call data\util.bat isAnswer %~6 valid
if %valid% EQU 0 goto error_invalidCorrectAnswer
endlocal
if [^%answer%] == [] goto skipReset
set "answer="
:skipReset
echo %~1
echo A) %~2
echo B) %~3
echo C) %~4
echo D) %~5
set /p answer="What is your answer? "
if [^%answer%] == [] goto invalid
set valid=0
call data\util.bat isAnswer ^%answer% valid
if %valid% EQU 0 goto invalid
set "valid="
if /i ^%answer% == %~6 goto correct
:incorrect
echo The answer is incorrect.
pause
goto question
:invalid
echo The answer is invalid.
pause
goto question
:correct
echo The answer is correct!
pause
endlocal
goto:eof
:error_invalidCorrectAnswer
echo Error: Corrent answer was not A, B, C or D.
pause
endlocal
goto:eof
