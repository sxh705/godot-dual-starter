@echo off
chcp 65001 >nul
set "JAVA_HOME=C:\Users\sxh705\godot\jdk-17.0.20.1+1"
set "ANDROID_HOME=C:\Users\sxh705\godot\android-sdk"
set "ANDROID_SDK_ROOT=%ANDROID_HOME%"
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%PATH%"
cd /d "%~dp0"
echo 正在导出 Windows 版...
"C:\Users\sxh705\godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path "%~dp0." --export-release "Windows Desktop" "build/windows/HelloGodot.exe"
echo.
if exist "build\windows\HelloGodot.exe" (echo 成功: build\windows\HelloGodot.exe) else (echo 失败，请查看上方日志)
pause
