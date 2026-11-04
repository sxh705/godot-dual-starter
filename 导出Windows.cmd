@echo off
chcp 65001 >nul
rem 引擎路径优先取环境变量 GODOT_BIN，其次用本机默认安装位置
if not defined GODOT_BIN set "GODOT_BIN=C:\Tools\Godot-4.7.2\Godot_v4.7.2-stable_win64.exe"
if not exist "%GODOT_BIN%" (
  echo 未找到 Godot 4.7.2 引擎。
  echo 请设置环境变量 GODOT_BIN 指向 Godot_v4.7.2-stable_win64.exe
  pause
  exit /b 1
)
set "GODOT_CONSOLE=%GODOT_BIN:_win64.exe=_win64_console.exe%"
if not defined JAVA_HOME if exist "C:\Users\%USERNAME%\scoop\apps\openjdk21\current\bin\java.exe" set "JAVA_HOME=C:\Users\%USERNAME%\scoop\apps\openjdk21\current"
if not defined ANDROID_HOME if exist "C:\Users\%USERNAME%\AppData\Local\Android\Sdk" set "ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk"
if defined ANDROID_HOME set "ANDROID_SDK_ROOT=%ANDROID_HOME%"
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%PATH%"
cd /d "%~dp0"
echo 正在导出 Windows 版...
"%GODOT_CONSOLE%" --headless --path "%~dp0." --export-release "Windows Desktop" "build/windows/HelloGodot.exe"
echo.
if exist "build\windows\HelloGodot.exe" (echo 成功: build\windows\HelloGodot.exe) else (echo 失败，请查看上方日志)
pause
