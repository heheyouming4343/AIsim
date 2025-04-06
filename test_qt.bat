@echo off
echo Testing Qt installation...

:: 检查Qt安装路径
echo Checking Qt installation paths...
if exist "C:\Qt\5.15.2\mingw81_64\bin\Qt5Core.dll" (
    echo Qt 5.15.2 found at C:\Qt\5.15.2\mingw81_64
) else (
    echo Qt 5.15.2 not found at C:\Qt\5.15.2\mingw81_64
    echo.
    echo Checking for other Qt installations...
    if exist "C:\Qt\*" (
        echo Found Qt installations:
        dir /b "C:\Qt\*"
    ) else (
        echo No Qt installations found in C:\Qt
    )
)

:: 检查MinGW安装
echo.
echo Checking MinGW installation...
if exist "C:\Qt\Tools\mingw810_64\bin\gcc.exe" (
    echo MinGW 8.1.0 found at C:\Qt\Tools\mingw810_64
    echo.
    echo Checking compiler versions:
    C:/Qt/Tools/mingw810_64/bin/gcc.exe --version
    C:/Qt/Tools/mingw810_64/bin/g++.exe --version
) else (
    echo MinGW 8.1.0 not found at C:\Qt\Tools\mingw810_64
)

:: 检查CMake安装
echo.
echo Checking CMake installation...
where cmake >nul 2>nul
if errorlevel 1 (
    echo CMake not found in PATH
) else (
    echo CMake found in PATH
    echo.
    echo Checking CMake version:
    cmake --version
)

:: 检查Qt模块
echo.
echo Checking Qt modules...
if exist "C:\Qt\5.15.2\mingw81_64\lib\cmake" (
    echo Qt CMake files found at C:\Qt\5.15.2\mingw81_64\lib\cmake
    echo.
    echo Available Qt modules:
    dir /b "C:\Qt\5.15.2\mingw81_64\lib\cmake\Qt5*"
) else (
    echo Qt CMake files not found at C:\Qt\5.15.2\mingw81_64\lib\cmake
)

:: 检查Qt DLLs
echo.
echo Checking Qt DLLs...
if exist "C:\Qt\5.15.2\mingw81_64\bin" (
    echo Qt DLLs found at C:\Qt\5.15.2\mingw81_64\bin
    echo.
    echo Available Qt DLLs:
    dir /b "C:\Qt\5.15.2\mingw81_64\bin\Qt5*.dll"
) else (
    echo Qt DLLs not found at C:\Qt\5.15.2\mingw81_64\bin
)

pause 