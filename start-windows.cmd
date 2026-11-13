@echo off
echo Starting Vineet's Third Eye at http://localhost:4173 - press Ctrl+C to stop.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\windows.ps1" -Action Dev
if errorlevel 1 pause
