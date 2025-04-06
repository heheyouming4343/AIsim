@echo off
echo Starting Reisim training environment...

REM Check common Anaconda installation paths
set ANACONDA_PATHS=^
C:\ProgramData\Anaconda3;^
C:\Users\%USERNAME%\Anaconda3;^
C:\Users\%USERNAME%\AppData\Local\Anaconda3;^
D:\Anaconda3

for %%p in (%ANACONDA_PATHS%) do (
    if exist "%%p\Scripts\activate.bat" (
        echo Found Anaconda at: %%p
        set ANACONDA_PATH=%%p
        goto :found_anaconda
    )
)

echo Error: Could not find Anaconda installation.
echo Please make sure Anaconda is installed.
echo Common installation paths checked:
for %%p in (%ANACONDA_PATHS%) do echo - %%p
pause
exit /b 1

:found_anaconda
echo Using Anaconda from: %ANACONDA_PATH%

REM Set environment variables
set PATH=%ANACONDA_PATH%;%ANACONDA_PATH%\Scripts;%ANACONDA_PATH%\Library\bin;%PATH%

REM Activate base environment
echo Activating base environment...
call "%ANACONDA_PATH%\Scripts\activate.bat"
if errorlevel 1 (
    echo Error: Could not activate base environment
    pause
    exit /b 1
)

REM Check if reisim environment exists
call conda env list | findstr /C:"reisim" > nul
if errorlevel 1 (
    echo Creating new environment 'reisim'...
    call conda create -n reisim python=3.9 -y
) else (
    echo Environment 'reisim' already exists
)

REM Activate environment
echo Activating reisim environment...
call conda activate reisim
if errorlevel 1 (
    echo Error: Could not activate reisim environment
    pause
    exit /b 1
)

REM Install required packages
echo Installing required packages...

REM First install MKL
echo Installing MKL...
call conda install -y mkl=2021.4.0
if errorlevel 1 goto :error

REM Install other packages
echo Installing other packages...
call conda install -y numpy
if errorlevel 1 goto :error
call conda install -y -c conda-forge gym
if errorlevel 1 goto :error
call conda install -y pytorch cpuonly -c pytorch
if errorlevel 1 goto :error
call conda install -y -c conda-forge stable-baselines3
if errorlevel 1 goto :error
call conda install -y -c conda-forge tensorboard
if errorlevel 1 goto :error
call pip install PyQt5
if errorlevel 1 goto :error

REM Set MKL environment variables
set MKL_THREADING_LAYER=INTEL
set MKL_SERVICE_FORCE_INTEL=1

REM Start Reisim
echo Starting Reisim...
start "" "%~dp0src\release\Reisim.exe"

REM Wait for Reisim to start
echo Waiting for Reisim to start...
timeout /t 5

REM Start training program
echo.
echo ========================================
echo Starting Training Interface
echo.
echo TRAINING INTERFACE INSTRUCTIONS:
echo 1. Click "Initialize Agent" to setup the agent
echo 2. Wait for initialization to complete
echo 3. Click "Start Training" to begin training
echo 4. Click "Stop Training" anytime to pause
echo 5. Training logs will appear in the interface
echo ========================================
echo.
python "%~dp0examples/train_lane_change.py"

goto :end

:error
echo Error occurred during package installation
pause
exit /b 1

:end
pause 