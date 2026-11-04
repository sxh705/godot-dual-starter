@echo off
chcp 65001 >nul
set "JAVA_HOME=C:\Users\sxh705\godot\jdk-17.0.20.1+1"
set "ANDROID_HOME=C:\Users\sxh705\godot\android-sdk"
set "ANDROID_SDK_ROOT=%ANDROID_HOME%"
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%PATH%"
start "" "C:\Users\sxh705\godot\Godot_v4.7.2-stable_win64.exe" --path "%~dp0." -e
