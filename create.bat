set dir_name="Spamerino"

if not exist %dir_name% (
mkdir %dir_name%/
mkdir %dir_name%/utils
)

xcopy "saves" "%dir_name%/saves" /E /I /Y
"D:\Programme\AutoIt3\Aut2Exe\Aut2Exe.exe" /in "src\spamerino.au3" /out "%dir_name%\spamerino.exe"

if "%~1"=="python" (
pyinstaller --onefile -w src/json_content.pyw
move "dist\json_content.exe" "%dir_name%\utils\"
RMDIR /S /Q dist
RMDIR /S /Q build
del json_content.spec
)
