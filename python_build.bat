@REM pyinstaller --onefile --noconsole --clean --add-data "images;images" --add-data "libs;libs" --add-data "libs/inter.dll;libs" main.py
pyinstaller --onefile --noconsole --clean --add-data "images;images" --add-data "libs/inter.dll;libs" main.py
