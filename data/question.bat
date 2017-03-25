@echo off
:: Question screen
:: Parameters:
:: 1 - question
:: 2-5 - answers
:: 6 - correct answer
:question question answer1 answer2 answer3 answer4 correctAnswer
setlocal
set /a "c=%~6"
if %c% lss 1 goto error_invalidCorrectAnswer
if %c% gtr 4 goto error_invalidCorrectAnswer
endlocal
setlocal
cls
echo Question %CURRENT_LEVEL%
echo %~1
echo 1) %~2
echo 2) %~3
echo 3) %~4
echo 4) %~5
set /p answer="What is your answer? "
set /a answer=answer
if %answer% == %~6 goto correct
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
echo Error: Corrent answer was not 1, 2, 3 or 4.
pause
endlocal
goto:eof
