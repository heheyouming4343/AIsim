@echo off
echo Starting Reisim training...

REM Set Anaconda path
set ANACONDA_PATH=C:\ProgramData\Anaconda3
set PATH=%ANACONDA_PATH%;%ANACONDA_PATH%\Scripts;%ANACONDA_PATH%\Library\bin;%PATH%

REM Activate environment
call "%ANACONDA_PATH%\Scripts\activate.bat"
call conda activate reisim

REM Set Python path
set PYTHONPATH=%~dp0
set PYTHONHOME=%ANACONDA_PATH%\envs\reisim

REM Start Reisim
echo Starting Reisim simulator...
start "" "%~dp0src\release\Reisim.exe"

REM Wait for Reisim to start
echo Waiting for simulator to start...
timeout /t 5

REM Start training
echo.
echo ========================================
echo Starting Training Interface
echo.
echo TRAINING INTERFACE EXPLANATION:
echo.
echo You will see two windows:
echo 1. Reisim Simulator - Shows the vehicle and road
echo 2. Training Control - PyQt5 window for training
echo.
echo TRAINING STEPS:
echo 1. Click "Initialize Agent" to setup the vehicle
echo 2. Wait for initialization to complete
echo 3. Click "Start Training" to begin learning
echo 4. Click "Stop Training" to pause
echo 5. Training logs will appear in the control window
echo.
echo The agent will learn to change lanes in the simulator
echo Training progress is saved in 'models' and 'logs' folders
echo ========================================
echo.
python "%~dp0examples/train_lane_change.py"

pause 