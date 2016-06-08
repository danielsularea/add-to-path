:: Adds a context menu entry to the explorer with 2 entries
:: `Add to path` and `Remove path`
:: They add the path to the environmental path of the local user.
:: NOTE: this works only when you right click on a file 
@ECHO OFF
SETLOCAL EnableDelayedExpansion

IF [%2]==[] CALL :SetRegistry
IF %2==A CALL :AddToPath %1 
IF %2==R CALL :RemovePath %1

EXIT /B

:SetRegistry
:: This label sets the registry keys which show up in the context menu 
:: on right click on a file
SETLOCAL
SET MainPath=hkcr\*\shell\AddToPath
SET ActionPath=hklm\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell

SET AddCmd=C:\Users\%USERNAME%\%~n0%~x0
SET RemCmd=C:\Users\%USERNAME%\%~n0%~x0

:: adds the entries
REG ADD "%MainPath%" /v MUIVerb /t reg_sz /d "Add to path" /f
REG ADD "%MainPath%" /v SubCommands /t reg_sz /d AddPath;RemovePath /f
 
:: now add the commands
REG add "%ActionPath%\AddPath" /t reg_sz /d "Add directory to path" /f
REG add "%ActionPath%\AddPath\command" /t reg_sz /d "%AddCmd% "\"%%1"\" A" /f
REG add "%ActionPath%\RemovePath" /t reg_sz /d "Remove from path" /f
REG add "%ActionPath%\RemovePath\command" /t reg_sz /d "%RemCmd% "\"%%1"\" R" /f
EXIT /B 


:AddToPath
FOR /F "usebackq tokens=3*" %%A in (`REG QUERY "hkcu\Environment" /v PATH`) DO (
	set Result=%%A %%B
)	

:: get the path to-be-added and remove the last slash
set DirToAdd=%Result%;%~dp1
set DirToAdd=%DirToAdd:~0,-1%
REG ADD "hkcu\Environment" /v PATH /t reg_expand_sz /d "%DirToAdd%" /f
EXIT /B


:RemovePath
FOR /F "usebackq tokens=3*" %%A in (`REG QUERY "hkcu\Environment" /v PATH`) DO (
	set Result=%%A %%B
)	

SET ToRemove=%~dp1
SET ToRemove=;%ToRemove:~0,-1%
CALL SET Result=%%Result:%ToRemove%=%%
REG ADD "hkcu\Environment" /v PATH /t reg_expand_sz /d "%Result%" /f
EXIT /B

