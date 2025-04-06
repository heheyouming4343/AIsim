@echo off
echo Starting Reisim training...

REM 激活conda环境
call conda activate reisim
if errorlevel 1 (
    echo Error: Could not activate reisim environment
    echo Please run setup_env.bat first
    pause
    exit /b 1
)

REM 启动Reisim
start "" "C:\Users\Sariely\Downloads\Reisim-master\src\release\Reisim.exe"

REM 等待Reisim启动
timeout /t 5

REM 启动训练程序
python train_reisim.py

pause 