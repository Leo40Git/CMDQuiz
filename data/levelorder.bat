@echo off
:: Level order
:lvlorder
if [%1]==[] goto lvl1
if %1 GTR %questionCount% goto lvl1
set lvl=lvl%1
goto %lvl%
:lvl1
set currentLevel=1
call data\question.bat "What is the most popular indie game?" Minecraft "Nuclear Throne" "The Binding of Isaac" Undertale A
:lvl2
set currentLevel=2
call data\question.bat " " "" "" "" "" A
:lvlorder_end
goto:eof
