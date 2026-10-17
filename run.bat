@echo off
rem ============================================================
rem 双击运行：Qml_test 最新构建版（Release）
rem 自带 Qt 运行时路径，不依赖系统 PATH / Qt Creator
rem 这份 exe 由命令行 qmake + mingw32-make 于 2026-10-17 编译
rem ============================================================
chcp 65001 >nul
set PATH=D:\Qt\Qt5.14.2\5.14.2\mingw73_64\bin;%PATH%
start "" "%~dp0build_cli\release\Qml_test.exe"
