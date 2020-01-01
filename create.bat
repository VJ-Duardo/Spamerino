set dir_name="Spamerino"

RMDIR /S /Q %dir_name%

mkdir %dir_name%/
mkdir %dir_name%/utils

xcopy "saves" "%dir_name%/saves" /E /I
"D:\Programme\AutoIt3\Aut2Exe\Aut2Exe.exe" /in "src\spamerino.au3" /out "%dir_name%\utils\spamerino.exe"
"D:\Programme\AutoIt3\Aut2Exe\Aut2Exe.exe" /in "src\start.au3" /out "%dir_name%\start.exe"

pyinstaller --onefile -w src/json_content.pyw
move "dist\json_content.exe" "%dir_name%\utils\"
RMDIR /S /Q dist
RMDIR /S /Q build
del json_content.spec
