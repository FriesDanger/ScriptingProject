@echo off


set LOGFILE=batch_log.txt
mkdir TestDir 2>> %LOGFILE% 2>nul
del %LOGFILE%

if exist TestDir (
	echo Current date and time: %date% %time%>> TestDir\%LOGFILE%
	echo Starting Batch script... >> TestDir\%LOGFILE%
)

if %ERRORLEVEL% neq 0 (
	echo Error: Failed to create directory. >> TestDir\%LOGFILE%
	exit /B 1
) else (
	echo Directory 'TestDir' created. >> TestDir\%LOGFILE%
	echo. >> TestDir\%LOGFILE%
	echo.>> TestDir\%LOGFILE%
	echo.>> TestDir\%LOGFILE%
	echo.>> TestDir\%LOGFILE%
	echo.>> TestDir\%LOGFILE%
)

python project1_python.py >> TestDir\batch_log.txt 2>&1

if %ERRORLEVEL% neq 0 (
echo Error calling Python script.
exit /B 1
)
rem --------------------------------------------------
rem			End of Script
rem --------------------------------------------------
