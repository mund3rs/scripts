@echo off
setlocal

REM Check if UEFI mode is enabled
set isUEFI=0

REM Get the boot configuration information
for /f "delims=" %%i in ('bcdedit /enum') do (
    echo %%i | find "\EFI\" > nul
    if not errorlevel 1 (
        set isUEFI=1
        echo System is using UEFI mode
        pause
        exit /b 0
    )
)

REM If UEFI mode is not found
if %isUEFI%==0 (
    echo System is using Legacy BIOS mode
    echo Converting from MBR to GPT...
    pause
    mbr2gpt /convert /disk:0 /allowfullos
    echo Conversion completed. Please check for errors and prepare to reboot into UEFI mode.
    pause
    REM Reboot into Windows Recovery Environment
    shutdown /r /o /f /t 0
)

exit /b
