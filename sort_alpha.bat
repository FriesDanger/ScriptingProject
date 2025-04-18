@echo off
setlocal EnableDelayedExpansion

set "main_folder=tracing_info"

REM Check if tracing_info exists
if not exist "%main_folder%" (
    echo Folder "%main_folder%" does not exist. Exiting.
    exit /b
)

REM === STEP 1: Extract from folders and flatten ===
set fields=hostname clientIp httpProtocol asn asOrganization colo country state city postalCode latitude longitude

for %%F in (%fields%) do (
    set "folder=%main_folder%\%%F"
    set "datafile=!folder!\%%F_data.txt"

    if exist "!datafile!" (
        set "value="

        for /f "usebackq delims=" %%A in ("!datafile!") do (
            set "value=%%A"
        )

        rd /s /q "!folder!"
        echo Removed folder: !folder!

        echo !value! > "%main_folder%\%%F_data.txt"
        echo Created: %main_folder%\%%F_data.txt with value: !value!
    ) else (
        echo Skipped %%F: no data file found at !datafile!
    )
)

REM === STEP 2: Alphabetically sort the new .txt files into folders ===
:: Change working directory to tracing_info
pushd "%cd%\tracing_info" || (
    echo Folder "tracing_info" not found.
    exit /b
)

:: Loop through all files (not directories) inside tracing_info
for /f "tokens=*" %%A in ('dir /b /a:-d') do (
    set "FIRSTCHAR=%%~nA"
    set "FIRSTCHAR=!FIRSTCHAR:~0,1!"

    :: Create subfolder if it doesn't exist
    if not exist "!FIRSTCHAR!" mkdir "!FIRSTCHAR!"

    :: Move the file into the correct subfolder
    move "%%A" "!FIRSTCHAR!\"
)

:: Return to original directory
popd

echo All done.
pause
