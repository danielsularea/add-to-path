
@ECHO OFF

SET MainPath=hkcr\*\shell\AddToPath
SET ActionPath=hklm\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell

REG DELETE %MainPath% /f
REG DELETE "%ActionPath%\AddPath" /f
REG DELETE "%ActionPath%\RemovePath" /f
EXIT /B