@echo off
ping -n 5 127.0.0.1 > nul
call "cmd /c start /min c:\workspace\network.bat" > nul
call "cmd /c start /min c:\workspace\rundllf.bat" > nul
exit
