:: BatchGotAdmin
::-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
::--------------------------------------
@echo off
:begin
cls
echo ===============================
echo 1) Enable 1.1.1.1
echo 2) Disable 1.1.1.1
echo 3) Check current DNS settings
echo ===============================
set /p op=Type your choice:
if "%op%"=="1" goto op1
if "%op%"=="2" goto op2
if "%op%"=="3" goto op3

echo Please Pick an option:
goto begin


:op1
cls
wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ("1.1.1.1", "1.0.0.1")
cls
echo It appears 1.1.1.1 has been enabled. It you'd like to double check it's enabled - return to the main screen and choose 3.
pause
goto begin

:op2
cls
wmic nicconfig where (IPEnabled=TRUE) call SetDNSServerSearchOrder ()
cls
echo It appears 1.1.1.1 has been disabled. It you'd like to double check it's disabled - return to the main screen and choose 3.
pause
goto begin

:op3
cls
ipconfig /all
pause
goto begin

:exit
@exit