@echo off
setlocal enabledelayedexpansion

echo =======================================
echo  WordPress Tailwind Theme Creator
echo =======================================
echo.

set /p THEME_NAME=Enter theme name:

if "!THEME_NAME!"=="" (
    echo Theme name cannot be empty.
    pause
    exit /b 1
)

:: Derive a PHP/CSS-safe slug: lowercase, non-alphanumeric runs become underscores
for /f "delims=" %%i in ('powershell -Command "'!THEME_NAME!'.ToLower() -replace '[^a-z0-9]+', '_' -replace '^_|_$', ''"') do set THEME_SLUG=%%i

set THEME_DIR=!THEME_NAME!-dev

echo.
echo Creating theme "!THEME_NAME!" in folder "!THEME_DIR!"...
echo.

mkdir "!THEME_DIR!"
if errorlevel 1 (
    echo Failed to create "!THEME_DIR!" - it may already exist.
    pause
    exit /b 1
)
cd "!THEME_DIR!"

:: -------------------------------------------------------
:: npm setup — pin Tailwind v3; v4 dropped tailwind.config.js
:: -------------------------------------------------------
echo [1/3] Initializing npm...
call npm init -y
if errorlevel 1 goto :error

echo [2/3] Installing Tailwind CSS v3...
call npm install tailwindcss@3
if errorlevel 1 goto :error

echo [3/3] Creating Tailwind config...
call npx tailwindcss init
if errorlevel 1 goto :error

:: -------------------------------------------------------
:: Overwrite tailwind.config.js with WordPress content paths
:: -------------------------------------------------------
(
    echo /** @type {import^('tailwindcss'^).Config} */
    echo module.exports = {
    echo   content: ["./*.php", "./**/*.php", "./assets/**/*.js"],
    echo   theme: {
    echo     extend: {},
    echo   },
    echo   plugins: [],
    echo }
) > tailwind.config.js

:: -------------------------------------------------------
:: Asset directories
:: -------------------------------------------------------
mkdir "assets\css"
mkdir "assets\js"

:: Tailwind input file — directives are required for output to be generated
(
    echo @tailwind base;
    echo @tailwind components;
    echo @tailwind utilities;
) > assets\css\tailwind.css

:: -------------------------------------------------------
:: Helper scripts
:: -------------------------------------------------------
(
    echo @echo off
    echo npx tailwindcss -i .\assets\css\tailwind.css -o .\assets\css\style.css --watch
) > watch.cmd

(
    echo @echo Not yet implemented
) > build.cmd

:: -------------------------------------------------------
:: style.css — WordPress theme header
:: -------------------------------------------------------
(
    echo /*
    echo Theme Name: !THEME_NAME!
    echo Theme URI:
    echo Author:
    echo Author URI:
    echo Description:
    echo Version: 1.0.0
    echo License: GNU General Public License v2 or later
    echo License URI: https://www.gnu.org/licenses/gpl-2.0.html
    echo Text Domain: !THEME_SLUG!
    echo */
) > style.css

:: -------------------------------------------------------
:: functions.php — enqueue compiled Tailwind output
:: -------------------------------------------------------
(
    echo ^<?php
    echo.
    echo function !THEME_SLUG!_enqueue_assets^(^) {
    echo     wp_enqueue_style^(
    echo         '!THEME_SLUG!-style',
    echo         get_template_directory_uri^(^) . '/assets/css/style.css',
    echo         array^(^),
    echo         wp_get_theme^(^)-^>get^( 'Version' ^)
    echo     ^)^;
    echo }
    echo add_action^( 'wp_enqueue_scripts', '!THEME_SLUG!_enqueue_assets' ^)^;
) > functions.php

:: -------------------------------------------------------
:: index.php — required minimum template (WordPress won't
:: recognize the theme without it)
:: -------------------------------------------------------
(
    echo ^<?php get_header^(^)^; ?^>
    echo.
    echo ^<main^>
    echo.
    echo     ^<?php
    echo     if ^( have_posts^(^) ^) :
    echo         while ^( have_posts^(^) ^) :
    echo             the_post^(^)^;
    echo             the_content^(^)^;
    echo         endwhile^;
    echo     endif^;
    echo     ?^>
    echo.
    echo ^</main^>
    echo.
    echo ^<?php get_footer^(^)^; ?^>
) > index.php

:: -------------------------------------------------------
echo.
echo =======================================
echo  Done! Theme "!THEME_NAME!" created.
echo =======================================
echo.
echo Folder : !THEME_DIR!\
echo.
echo Next steps:
echo   cd !THEME_DIR!
echo   watch.cmd        ^<-- start Tailwind in watch mode
echo   build.cmd        ^<-- (not yet implemented)
echo.
echo Activate the theme in WordPress Admin ^> Appearance ^> Themes.
echo.
pause
exit /b 0

:error
echo.
echo Something went wrong. Check the output above.
pause
exit /b 1
