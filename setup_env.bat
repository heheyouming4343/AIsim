@echo off
setlocal enabledelayedexpansion

echo Setting up Reisim training environment...

:: Set Anaconda paths
set "CONDA_ROOT=C:\ProgramData\Anaconda3"
set "CONDA_BAT=%CONDA_ROOT%\Scripts\activate.bat"
set "CONDA_EXE=%CONDA_ROOT%\Scripts\conda.exe"

if not exist "%CONDA_ROOT%" (
    echo Anaconda not found at %CONDA_ROOT%
    echo Please install Anaconda or modify the script with the correct path.
    pause
    exit /b 1
)

echo Found Anaconda at: %CONDA_ROOT%

:: Remove existing environment if exists
echo Checking for existing environment...
call "%CONDA_EXE%" env list | findstr /C:"reisim" > nul
if %ERRORLEVEL% EQU 0 (
    echo Removing existing reisim environment...
    call "%CONDA_EXE%" env remove -n reisim -y
)

:: Create new environment with Python 3.9
echo Creating new conda environment...
call "%CONDA_EXE%" create -n reisim python=3.9 -y

:: Activate environment
echo Activating environment...
call "%CONDA_BAT%" activate reisim

:: Install packages using conda
echo Installing required packages...

:: Install numpy
echo Installing numpy...
call "%CONDA_EXE%" install -n reisim numpy=1.24.3 -y

:: Install pytorch
echo Installing pytorch...
call "%CONDA_EXE%" install -n reisim pytorch=2.0.1 cpuonly -c pytorch -y

:: Install gymnasium
echo Installing gymnasium...
call "%CONDA_EXE%" install -n reisim -c conda-forge gymnasium=0.29.1 -y

:: Install stable-baselines3
echo Installing stable-baselines3...
call "%CONDA_EXE%" install -n reisim -c conda-forge stable-baselines3=2.1.0 -y

:: Install tensorboard
echo Installing tensorboard...
call "%CONDA_EXE%" install -n reisim tensorboard=2.13.0 -y

:: Install PyQt5
echo Installing PyQt5...
call "%CONDA_EXE%" install -n reisim pyqt=5.15.9 -y

:: Create necessary directories
echo Creating directories...
if not exist "models" mkdir models
if not exist "logs" mkdir logs

:: Set PYTHONPATH
set "PYTHONPATH=%CD%;%PYTHONPATH%"

:: Verify installation
echo Verifying installation...
call "%CONDA_EXE%" run -n reisim python -c "import numpy; import torch; import gymnasium; import stable_baselines3; import tensorboard; import PyQt5; print('All packages installed successfully!')"

if %ERRORLEVEL% EQU 0 (
    echo Environment setup completed successfully!
    echo.
    echo Starting training...
    call "%CONDA_EXE%" run -n reisim python examples/train_lane_change.py
) else (
    echo Environment setup failed. Please check the error messages above.
    pause
    exit /b 1
)

goto :eof 