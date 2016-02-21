@echo off
:: Level order
:lvlorder
set currentlvl=0
:lvl1
set currentlvl=1
call data\question.bat "What is the most popular indie game?" Minecraft "Nuclear Throne" "The Binding of Isaac" Undertale A
:lvlorder_end
goto:eof