@echo off
setlocal enabledelayedexpansion

echo =======================================
echo  WordPress Tailwind Theme Build
echo =======================================
echo.

:: Theme name = current folder name
for %%I in ("%CD%") do set THEME_NAME=%%~nxI

:: Absolute path of parent directory
for %%I in ("%CD%\..") do set PARENT_DIR=%%~fI

:: -------------------------------------------------------
:: Step 1: Compile Tailwind CSS
:: -------------------------------------------------------
echo [1/2] Compiling Tailwind CSS...
call npx tailwindcss -i .\assets\css\tailwind.css -o .\assets\css\style.css
if errorlevel 1 (
    echo.
    echo ERROR: Tailwind compilation failed.
    pause
    exit /b 1
)
echo.

:: -------------------------------------------------------
:: Step 2: Package into a zip
:: -------------------------------------------------------
echo [2/2] Packaging theme...

:: Backup style.css then strip -dev from Theme Name and Text Domain
:: so the zip gets the release version; restored after zipping
copy /y style.css style.css.bak > nul
powershell -NoProfile -Command "$f = 'style.css'; (Get-Content $f) -replace '(-dev)(\s*)$', '$2' | Set-Content $f"
if errorlevel 1 (
    echo.
    echo ERROR: Failed to update style.css.
    copy /y style.css.bak style.css > nul
    del style.css.bak
    pause
    exit /b 1
)

set BUILD_TMP=%TEMP%\!THEME_NAME!_build
if exist "!BUILD_TMP!" rmdir /s /q "!BUILD_TMP!"

:: Copy everything except: .cmd files, node_modules, package files,
:: tailwind config, and the Tailwind source CSS (compiled output stays)
robocopy "." "!BUILD_TMP!" /E /XD node_modules /XF *.cmd package.json package-lock.json tailwind.config.js tailwind.css *.bak > nul
if errorlevel 8 (
    echo.
    echo ERROR: Failed to stage files for packaging.
    copy /y style.css.bak style.css > nul
    del style.css.bak
    pause
    exit /b 1
)

:: Restore style.css to its -dev state
copy /y style.css.bak style.css > nul
del style.css.bak

set ZIP_NAME=!THEME_NAME:-dev=!
set ZIP_OUT=!PARENT_DIR!\!ZIP_NAME!.zip
if exist "!ZIP_OUT!" del /f "!ZIP_OUT!"

powershell -NoProfile -Command "Compress-Archive -Path '!BUILD_TMP!\*' -DestinationPath '!ZIP_OUT!'"
if errorlevel 1 (
    echo.
    echo ERROR: Zip creation failed.
    rmdir /s /q "!BUILD_TMP!"
    pause
    exit /b 1
)

rmdir /s /q "!BUILD_TMP!"

echo.
echo =======================================
echo  Done! Created: !ZIP_NAME!.zip
echo =======================================
echo.
pause
