SET VERSION=0.2.1

@REM Compilar scripts de Python
python -m compileall -b ./scripts

@REM Crear instalador
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" /dMyAppVersion="%VERSION%" installer.iss 
