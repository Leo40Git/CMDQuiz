@echo off
:: Menu screen
:main
cls
echo(
echo  +----------------------------------------+
echo  ^|   ____ __  __ ____   ___        _      ^|
echo  ^|  / ___^|  \/  ^|  _ \ / _ \ _   _(_)____ ^|
echo  ^| ^| ^|   ^| ^|\/^| ^| ^| ^| ^| ^| ^| ^| ^| ^| ^| ^|_  / ^|
echo  ^| ^| ^|___^| ^|  ^| ^| ^|_^| ^| ^|_^| ^| ^|_^| ^| ^|/ /  ^|
echo  ^|  \____^|_^|  ^|_^|____/ \__\_\\__,_^|_/___^| ^|
echo  ^|                                        ^|
echo  +----------------------------------------+
echo  Version %version% (build %build%)
echo(
echo Main Menu
echo A) Start new game
echo B) Continue existing game
echo C) Instructions
echo D) Change color
echo E) About the game
echo F) Quit
if "%menu%"=="" goto skipResetMenu
set "menu="
:skipResetMenu
set /p menu="What is your selection? "
if "%menu%"=="" goto invalid
if /i %menu% == A goto startGame
if /i %menu% == B goto continueGame
if /i %menu% == C goto instructions
if /i %menu% == D goto color
if /i %menu% == E goto about
if /i %menu% == F goto quit
:invalid
echo Error: Invalid selection.
pause
goto main
:startGame
set currentLevel=1
goto bootGame
:continueGame
if not exist %SAVE_FILE_NAME% goto continueGame_noSave
call data\util.bat gameLoad %SAVE_FILE_NAME%
goto bootGame
:continueGame_noSave
echo Error: No save found.
pause
goto main
:bootGame
call data\levelorder.bat %currentLevel%
cls
echo Congrats! You completed the game!
pause
goto main
:instructions
echo In each level, you will be asked a question.
echo You will need to choose an answer, and only one is correct, so choose wisley!
pause
goto main
:color
call data\colormenu.bat
goto main
:about
echo CMDQuiz Version %version% (build %build%)
echo A quiz game being made in native Batch script.
echo Feel free to modify these scripts to your liking, just remember to credit me if you're going to distribute
echo the modified versions. See "LICENSE" for more information.
pause
goto main
:quit
if "%quit%"=="" goto skipResetQuit
set "quit="
:skipResetQuit
echo Are you sure you want to quit?
set /p quit="[Y/N] "
if /i %quit% == Y (goto exitFunc) else (goto main)
:exitFunc
echo _>quit.txt
cls
color
goto:eof
