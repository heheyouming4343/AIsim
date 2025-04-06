@echo off
echo Setting up Qt environment...

:: 检查Qt安装路径
if not exist "C:\Qt\5.15.2\mingw81_64\bin\Qt5Core.dll" (
    echo Error: Qt not found at C:\Qt\5.15.2\mingw81_64
    echo Please install Qt 5.15.2 with MinGW 8.1.0 64-bit
    echo.
    echo Checking for other Qt installations...
    if exist "C:\Qt\*" (
        echo Found Qt installations:
        dir /b "C:\Qt\*"
    ) else (
        echo No Qt installations found in C:\Qt
    )
    pause
    exit /b 1
)

:: 检查MinGW安装
if not exist "C:\Qt\Tools\mingw810_64\bin\gcc.exe" (
    echo Error: MinGW not found at C:\Qt\Tools\mingw810_64
    echo Please install MinGW 8.1.0 64-bit
    pause
    exit /b 1
)

:: 检查CMake安装
where cmake >nul 2>nul
if errorlevel 1 (
    echo Error: CMake not found in PATH
    echo Please install CMake
    pause
    exit /b 1
)

:: 设置Qt环境变量
set PATH=C:\Qt\5.15.2\mingw81_64\bin;C:\Qt\Tools\mingw810_64\bin;%PATH%
set QTDIR=C:\Qt\5.15.2\mingw81_64
set QT_PLUGIN_PATH=C:\Qt\5.15.2\mingw81_64\plugins
set QT_QPA_PLATFORM_PLUGIN_PATH=C:\Qt\5.15.2\mingw81_64\plugins\platforms

echo Environment variables set:
echo PATH=%PATH%
echo QTDIR=%QTDIR%
echo QT_PLUGIN_PATH=%QT_PLUGIN_PATH%
echo QT_QPA_PLATFORM_PLUGIN_PATH=%QT_QPA_PLATFORM_PLUGIN_PATH%

echo.
echo Cleaning build directory...
if exist build rmdir /s /q build
mkdir build

echo.
echo Configuring CMake...
cd build
echo Current directory: %CD%

:: 使用更简单的CMake命令
cmake .. -G "MinGW Makefiles" ^
    -DCMAKE_C_COMPILER=C:/Qt/Tools/mingw810_64/bin/gcc.exe ^
    -DCMAKE_CXX_COMPILER=C:/Qt/Tools/mingw810_64/bin/g++.exe ^
    -DCMAKE_MAKE_PROGRAM=C:/Qt/Tools/mingw810_64/bin/mingw32-make.exe ^
    -DCMAKE_PREFIX_PATH=C:/Qt/5.15.2/mingw81_64/lib/cmake

if errorlevel 1 (
    echo Error: CMake configuration failed
    echo.
    echo Checking CMake version:
    cmake --version
    echo.
    echo Checking compiler versions:
    C:/Qt/Tools/mingw810_64/bin/gcc.exe --version
    C:/Qt/Tools/mingw810_64/bin/g++.exe --version
    echo.
    echo Checking Qt installation:
    dir "C:\Qt\5.15.2\mingw81_64\lib\cmake"
    cd ..
    pause
    exit /b 1
)

echo.
echo Building project...
cmake --build .

if errorlevel 1 (
    echo Error: Build failed
    cd ..
    pause
    exit /b 1
)

echo.
echo Running application...
:: 检查多个可能的位置
if exist bin\Reisim.exe (
    echo Starting Reisim from bin directory...
    bin\Reisim.exe
) else if exist Reisim.exe (
    echo Starting Reisim from current directory...
    Reisim.exe
) else (
    echo Error: Executable not found
    echo Searching for Reisim.exe...
    dir /s /b Reisim.exe
    if errorlevel 1 (
        echo No Reisim.exe found in the build directory
        echo Current directory: %CD%
        echo Listing build directory contents:
        dir /s
    ) else (
        echo Found Reisim.exe, attempting to run it...
        for /f "delims=" %%i in ('dir /s /b Reisim.exe') do (
            echo Running: %%i
            "%%i"
        )
    )
    pause
    exit /b 1
)

cd ..
pause 