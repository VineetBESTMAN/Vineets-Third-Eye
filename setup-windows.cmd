@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\windows.ps1" -Action Install
if errorlevel 1 (
  pause
  exit /b 1
)
echo Setup complete. Run start-windows.cmd and open http://localhost:4173
pause
