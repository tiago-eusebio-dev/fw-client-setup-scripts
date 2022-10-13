@echo off

@REM ipconfig|find/i "vpn_primavera" || rasdial vpn_primavera
@REM echo.

set REM_DIST=0
set _rem_dist=Y
set /p _rem_dist="> Delete dist folder? (Y/n): "
if %_rem_dist%==y set REM_DIST=1
if %_rem_dist%==Y set REM_DIST=1

set REM_COVERAGE=0
set _rem_coverage=N
set /p _rem_coverage="> Delete .coverage folder? (y/N): "
if %_rem_coverage%==y set REM_COVERAGE=1
if %_rem_coverage%==Y set REM_COVERAGE=1

set INSTALL=0
set _install=N
set /p _install="> Run npm install? (y/N): "
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

set UPDATE=0
set _update=N
if %INSTALL% EQU 0 (
    set /p _update="> Run npm update? (y/N): "
)
if %_update%==y set UPDATE=1
if %_update%==Y set UPDATE=1

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

set TEST=0
set _test=N
set /p _test="> Test? (y/N): "
if %_test%==y set TEST=1
if %_test%==Y set TEST=1

FOR /F "tokens=*" %%g IN ('npm list -g --depth=0 rimraf') do (SET rimraf_status=%%g)
if "x%rimraf_status:rimraf=%" == "x%rimraf_status%" (
    call echo.
    call echo - Installing rimraf globally...
    call npm i -g rimraf
)

echo.

call echo ####################################################################
call echo SETTING UP ClientApp
call echo ####################################################################

if %REM_DIST% EQU 1 (
    if exist .\dist\ (
        call echo - Deleting dist folder...
        call rimraf .\dist
    )
)


if %REM_COVERAGE% EQU 1 (
    if exist .\.coverage\ (
        call echo - Deleting .coverage folder...
        call rimraf .\.coverage
    )
)

if %UPDATE% EQU 1 (
    call echo - Unlinking @primavera/themes (it is normal if it throws an EPERM error)
    call npm unlink @primavera/themes
    call echo - Running npm update...
    call npm update
    call npm link @primavera/themes
) 

if %INSTALL% EQU 1 (
    if exist .\package-lock.json (
        call echo - Deleting package-lock.json...
        call del package-lock.json
    )

    if exist .\node_modules\ (
        call echo - Unlinking @primavera/themes (it is normal if it throws an EPERM error)
        call npm unlink @primavera/themes
        call echo - Deleting node_modules folder...
        call rimraf .\node_modules
    )

    if exist .\src\generated-code (
        call echo - Deleting src/generated-code folder...
        call rimraf .\src\generated-code
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

if %TEST% EQU 1 (
    if exist .\.coverage\ (
        call echo - Deleting .coverage folder...
        call rimraf .\.coverage
    )
    if exist .\node_modules\ (
        call echo - Testing...
        call npm run test:prod
    )
) 

echo.
set /p=DONE! Hit ENTER to exit...


@REM  *Review date: 13/10/2022*
@REM  *Tiago Eusébio @ INT-C*
@REM  *© PRIMAVERA BSS*