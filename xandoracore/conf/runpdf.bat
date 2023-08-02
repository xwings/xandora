@echo off
ping -n 5 127.0.0.1 > nul
call "cmd /c start c:\workspace\network.bat" > nul
call "cmd /c start c:\windows\explorer.exe c:\workspace\sample.pdf" > nul
exit
