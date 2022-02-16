@echo off

ipconfig|find/i "vpn_primavera" || rasdial vpn_primavera
echo.

set INSTALL=0
set _install=Y
set /p _install="> Run npm install? (Y/n): "
if %_install%==y set INSTALL=1
if %_install%==Y set INSTALL=1

set FORCE=0
set _force=N
if %INSTALL% EQU 1 (
    @REM set _force=Y
    call set /p _force="> Force npm install? (y/N): "
)
if %_force%==y call set FORCE=1
if %_force%==Y call set FORCE=1

set LINT=0
set _lint=N
set /p _lint="> Perform Linting? (y/N): "
if %_lint%==y set LINT=1
if %_lint%==Y set LINT=1

set BUILD=0
set _build=N
set /p _build="> Build? (y/N): "
if %_build%==y set BUILD=1
if %_build%==Y set BUILD=1

echo.

call echo ####################################################################
call echo SETTING UP ClientApp
call echo ####################################################################

if exist .\dist\ (
    call echo - Deleting dist folder...
    call rimraf .\dist
)

if %INSTALL% EQU 1 (
    if exist .\package-lock.json (
        call echo - Deleting package-lock.json...
        call del package-lock.json
    )

    if exist .\node_modules\ (
        call echo - Deleting node_modules folder...
        call rimraf .\node_modules
    )

    if %FORCE% EQU 1 (
        call echo - Installing dependencies in forced mode...
        call npm i --force
    ) else (
        call echo - Installing dependencies...
        call npm i
    )

    call npm link @primavera/themes
)

if %LINT% EQU 1 (
    if exist .\node_modules\ (
        call echo - Running lint...
        call npm run lint
    )
) 
    
if %BUILD% EQU 1 (
    if exist .\node_modules\ (
        call echo - Building...
        call npm run build:dev
    )
)

echo.
set /p=DONE! Hit ENTER to exit...