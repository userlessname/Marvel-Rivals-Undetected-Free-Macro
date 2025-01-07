@echo off

:: Navigate to the directory of the script
cd /d "%~dp0"

:: Run the command
install-interception.exe /install

:: Pause to display output
pause