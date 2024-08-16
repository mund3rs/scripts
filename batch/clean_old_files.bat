@echo off
:: Define the directory and the number of days
set directory=C:\path\to\directory
set days=30

:: Delete files older than the specified number of days
forfiles -p "%directory%" -s -m *.* -d -%days% -c "cmd /c del /q @path"

echo Files older than %days% days have been deleted!
pause
