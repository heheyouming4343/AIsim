@echo off
echo Setting up Qt environment...

:: 设置Qt环境变量
set PATH=C:\Qt\5.15.2\mingw81_64\bin;C:\Qt\Tools\mingw810_64\bin;%PATH%
set QTDIR=C:\Qt\5.15.2\mingw81_64
set QT_PLUGIN_PATH=C:\Qt\5.15.2\mingw81_64\plugins
set QT_QPA_PLATFORM_PLUGIN_PATH=C:\Qt\5.15.2\mingw81_64\plugins\platforms

echo Cleaning build directory...
if exist build rmdir /s /q build
mkdir build

echo Configuring CMake...
cmake -B build -S . -G "MinGW Makefiles" ^
    -DCMAKE_C_COMPILER=C:/Qt/Tools/mingw810_64/bin/gcc.exe ^
    -DCMAKE_CXX_COMPILER=C:/Qt/Tools/mingw810_64/bin/g++.exe ^
    -DCMAKE_MAKE_PROGRAM=C:/Qt/Tools/mingw810_64/bin/mingw32-make.exe ^
    -DCMAKE_PREFIX_PATH=C:/Qt/5.15.2/mingw81_64/lib/cmake

echo Building project...
cmake --build build --verbose

echo Deploying Qt dependencies...
if exist build\bin\Reisim.exe (
    C:\Qt\5.15.2\mingw81_64\bin\windeployqt.exe build\bin\Reisim.exe
)

echo Done!
pause 