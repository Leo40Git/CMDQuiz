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
echo(
echo  Version %VERSION% (build %BUILD%)
echo(
echo Main Menu
echo A) Start new game
echo B) Continue existing game
echo C) Instructions
echo D) Change color
echo E) About the game
echo F) View changelog
echo G) Quit
if not [^%menu%] == [] set "menu="
set /p menu="What is your selection? "
if [^%menu%] == [] goto invalid
if /i ^%menu% == A goto startGame
if /i ^%menu% == B goto continueGame
if /i ^%menu% == C goto instructions
if /i ^%menu% == D goto color
if /i ^%menu% == E goto about
if /i ^%menu% == F goto changelog
if /i ^%menu% == G goto quit
:invalid
echo Invalid selection.
pause
goto main
:startGame
if not exist %SAVE_FILE_NAME% goto startGame_noExistingSave
if not [^%newGame%] == [] set "newGame="
echo An existing save was found!
echo Are you sure you want to delete it and start a new game?
set /p newGame="[Y/N] "
if /i ^%newGame% == Y (goto startGame_noExistingSave) else (goto main)
:startGame_noExistingSave
set CURRENT_LEVEL=1
goto bootGame
:continueGame
if not exist %SAVE_FILE_NAME% goto continueGame_errorNoSave
set success=0
call data\util.bat gameLoad %SAVE_FILE_NAME% success
if %success% EQU 0 goto continueGame_errorLoadFailed
goto bootGame
:continueGame_errorNoSave
echo No save found.
pause
goto main
:continueGame_errorLoadFailed
echo Could not load save. This is probably because the save was modified and the values are invalid.
pause
goto main
:bootGame
call data\levelorder.bat %CURRENT_LEVEL%
cls
echo Congrats^! You completed the game^!
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
echo CMDQuiz Version %VERSION% (build %BUILD%)
echo A quiz game being made in native Batch script.
echo Feel free to modify these scripts to your liking, just remember to credit me if you're going to distribute
echo the modified versions. See "LICENSE" for more information.
pause
goto main
:changelog
cls
if exist Changelog.txt (type Changelog.txt) else goto changelog_error_notExists
pause
goto main
:changelog_error_notExists
echo Error: Changelog file does not exist???
pause
goto main
:quit
if not [^%quit%] == [] set "quit="
echo Are you sure you want to quit?
set /p quit="[Y/N] "
if /i ^%quit% == Y (goto exitFunc) else (goto main)
:exitFunc
cls
color
goto:eof
