@echo off

@REM ipconfig|find/i "vpn_primavera" || rasdial vpn_primavera
@REM echo.

@REM Runs the script as Administrator (if not already running as Administrator)
@REM This is needed in order to change the npmrc
@REM set "params=%*"
@REM cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

@REM call npmrc elevation

set Arr[0]=ngbusinesscore
set Arr[1]=ngmaintenance
set Arr[2]=ngplanner
set Arr[3]=vkplanner
set Arr[4]=webcomponents

set ArrLen=0
:Loop 
if defined ARR[%ArrLen%] ( 
    set /a ArrLen+=1
    GOTO :Loop 
)

set REM_DIST=0
set _rem_dist=Y
set /p _rem_dist="> Delete dist folder? (Y/n): "
if %_rem_dist%==y set REM_DIST=1
if %_rem_dist%==Y set REM_DIST=1

set REM_COVERAGE=0
set _rem_coverage=Y
set /p _rem_coverage="> Delete .coverage folder? (Y/n): "
if %_rem_coverage%==y set REM_COVERAGE=1
if %_rem_coverage%==Y set REM_COVERAGE=1

set INSTALL=0
set _install=N
set /p _install="> Run npm install? (y/N): "
if %_install%==y set INSTALL=1
if %_install%==Y set INSTALL=1

set FORCE=0
set _force=N
set PRI_ONLY=0
set _pri_only=N
if %INSTALL% EQU 1 (
    @REM set _force=Y
    call set /p _force="> Force npm install? (y/N): "

    @REM set _pri_only=Y
    call set /p _pri_only="> Reinstall PRIMAVERA/PROTOTYPE dependencies only? (y/N): "
)
if %_force%==y call set FORCE=1
if %_force%==Y call set FORCE=1
if %_pri_only%==y call set PRI_ONLY=1
if %_pri_only%==Y call set PRI_ONLY=1

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
set x=0
set position=0

:SymLoop
if defined Arr[%x%] (
    call set MODULE=%%Arr[%x%]%%
    call set /a position+=1
    call echo ####################################################################
    call echo SETTING UP %%MODULE%% - %%position%% of %%ArrLen%%
    call echo ####################################################################
    call cd %%MODULE%%

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

    if %INSTALL% EQU 1 (
        if exist .\package-lock.json (
            call echo - Deleting package-lock.json...
            call del package-lock.json
        )

        if %PRI_ONLY% EQU 1 (
            call echo - Installing only PRIMAVERA/PROTOTYPE dependencies...
            if exist .\node_modules\@primavera (
                call echo - Deleting @primavera folder...
                call rimraf .\node_modules\@primavera
            )
            if exist .\node_modules\@prototype (
                call echo - Deleting @prototype folder...
                call rimraf .\node_modules\@prototype
            )
        ) else (
            call echo - Installing dependencies...
            if exist .\node_modules\ (
                call echo - Deleting node_modules folder...
                call rimraf .\node_modules
            )
            if exist .\.angular\ (
                call echo - Deleting .angular folder...
                call rimraf .\.angular
            )		
        )
        
        if %FORCE% EQU 1 (
            call echo - Installing dependencies in forced mode...
            call npm i --force
        ) else (
            call echo - Installing dependencies...
            call npm i
        )
    )

    if %UPDATE% EQU 1 (
        call echo - Running npm update...
        call npm update
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

    call cd ..
    set /a x+=1
    goto :SymLoop
)
echo.
set /p=DONE! Hit ENTER to exit...



@REM Operator | Description
@REM EQU      | equal to
@REM NEQ      | not equal to
@REM LSS      | less than
@REM LEQ      | less than or equal to
@REM GTR      | greater than
@REM GEQ      | greater than or equal to
@REM not      | used to negate a condition.


@REM  *Review date: 24/11/2022*
@REM  *Tiago Eusébio @ INT-C*
@REM  *© PRIMAVERA BSS*