@echo off
start "" FULLTRAP_NATIVE.exe
timeout /t 2 >nul
start "" powershell -ExecutionPolicy Bypass -File ghost_watchdog.ps1