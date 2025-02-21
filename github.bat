@echo off
:: Pedir la ruta del proyecto y la rama
set /p REPO_PATH=Introduce la ruta del proyecto: 
set /p BRANCH=Introduce el nombre de la rama: 

:: Verificar si la ruta ingresada existe
if not exist "%REPO_PATH%" (
    echo Error: La ruta del proyecto no existe.
    pause
    exit /b
)

:: Cambiar al directorio del repositorio
cd /d "%REPO_PATH%"

:: Verificar si es un repositorio Git
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo Error: No es un repositorio Git válido.
    pause
    exit /b
)

:: Obtener cambios realizados
git status > cambios.txt
set MESSAGE=

for /f "tokens=2 delims=:" %%a in ('findstr /C:"modificado" cambios.txt') do set MESSAGE=Actualización: %%a
for /f "tokens=2 delims=:" %%a in ('findstr /C:"nuevo archivo" cambios.txt') do set MESSAGE=Nuevos archivos agregados
for /f "tokens=2 delims=:" %%a in ('findstr /C:"borrado" cambios.txt') do set MESSAGE=Se han eliminado archivos

:: Si no hay cambios, salir
if not defined MESSAGE (
    echo No hay cambios para subir.
    del cambios.txt
    pause
    exit /b
)

:: Agregar archivos al commit
git add .

:: Realizar commit con mensaje generado automáticamente
git commit -m "%MESSAGE%"

:: Subir cambios a GitHub
git push origin %BRANCH%

:: Limpiar archivo temporal
del cambios.txt

echo Cambios subidos con éxito a la rama %BRANCH% en GitHub!
pause
