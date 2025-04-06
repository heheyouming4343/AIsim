@echo off
echo Building test application...

:: 检查Qt安装
if not exist "C:\Qt\5.15.2\mingw81_64\bin\Qt5Core.dll" (
    echo Error: Qt 5.15.2 not found at C:\Qt\5.15.2\mingw81_64
    echo Please run test_qt.bat to check Qt installation
    pause
    exit /b 1
)

:: 检查MinGW安装
if not exist "C:\Qt\Tools\mingw810_64\bin\gcc.exe" (
    echo Error: MinGW 8.1.0 not found at C:\Qt\Tools\mingw810_64
    echo Please run test_qt.bat to check MinGW installation
    pause
    exit /b 1
)

:: 设置环境变量
set PATH=C:\Qt\5.15.2\mingw81_64\bin;C:\Qt\Tools\mingw810_64\bin;%PATH%
set CMAKE_PREFIX_PATH=C:\Qt\5.15.2\mingw81_64\lib\cmake

:: 清理build目录
if exist build (
    echo Cleaning build directory...
    rmdir /s /q build
)

:: 创建build目录
mkdir build
cd build

:: 配置CMake
echo Configuring CMake...
cmake .. -G "MinGW Makefiles" ^
    -DCMAKE_C_COMPILER=C:/Qt/Tools/mingw810_64/bin/gcc.exe ^
    -DCMAKE_CXX_COMPILER=C:/Qt/Tools/mingw810_64/bin/g++.exe ^
    -DCMAKE_MAKE_PROGRAM=C:/Qt/Tools/mingw810_64/bin/mingw32-make.exe

if errorlevel 1 (
    echo Error: CMake configuration failed
    cd ..
    pause
    exit /b 1
)

:: 构建项目
echo Building project...
cmake --build .

if errorlevel 1 (
    echo Error: Build failed
    cd ..
    pause
    exit /b 1
)

:: 复制Qt DLLs
echo Copying Qt DLLs...
copy /y "C:\Qt\5.15.2\mingw81_64\bin\Qt5Core.dll" .
copy /y "C:\Qt\5.15.2\mingw81_64\bin\Qt5Gui.dll" .
copy /y "C:\Qt\5.15.2\mingw81_64\bin\Qt5Widgets.dll" .
copy /y "C:\Qt\5.15.2\mingw81_64\bin\libgcc_s_seh-1.dll" .
copy /y "C:\Qt\5.15.2\mingw81_64\bin\libstdc++-6.dll" .
copy /y "C:\Qt\5.15.2\mingw81_64\bin\libwinpthread-1.dll" .

:: 运行测试程序
echo Running test application...
Reisim.exe

cd ..
pause 