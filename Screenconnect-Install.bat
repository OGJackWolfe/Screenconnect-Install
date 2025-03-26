@echo off
setlocal enabledelayedexpansion

:: Setup deployment URL  --PUT IN YOUR SITE PREFIX!--
set "DeploymentURL=https://YOURSITE.screenconnect.com/Bin/ScreenConnect.ClientSetup.msi"

:: Define the service name to search for (change this as needed)
set "SEARCH_SERVICE=ScreenConnect"

:: Initialize found flag
set "FOUND="

:: Search for the service
for /f "tokens=*" %%A in ('sc query state^= all ^| findstr /I /C:"SERVICE_NAME: %SEARCH_SERVICE%"') do (
    set "FOUND=1"
)

:: Check if the service was found
if defined FOUND (
    echo Service "%SEARCH_SERVICE%" found. Exiting...
) else (
    echo Service "%SEARCH_SERVICE%" NOT found.
    echo Performing install...
    if not exist c:\Temp md c:\Temp
    cd c:\Temp
    powershell Invoke-WebRequest "%DeploymentURL%" -Outfile ScreenConnect.ClientSetup.msi
    msiexec.exe /i ScreenConnect.ClientSetup.msi /quiet /norestart
)

exit /b
