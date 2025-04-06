@echo off
setx PATH "%PATH%;C:\Qt\5.15.2\mingw81_64\bin;C:\Qt\Tools\mingw810_64\bin" /M
setx QTDIR "C:\Qt\5.15.2\mingw81_64" /M
setx QT_PLUGIN_PATH "C:\Qt\5.15.2\mingw81_64\plugins" /M
setx QT_QPA_PLATFORM_PLUGIN_PATH "C:\Qt\5.15.2\mingw81_64\plugins\platforms" /M
echo Qt environment variables have been set.
pause 