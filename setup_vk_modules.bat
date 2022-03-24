@echo off

ipconfig|find/i "vpn_primavera" || rasdial vpn_primavera
echo.

@REM Runs the script as Administrator (if not already running as Administrator)
@REM This is needed in order to change the npmrc
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

call npmrc valuekeep

set Arr[0]=ngbusinesscore
set Arr[1]=ngmaintenance
set Arr[2]=vkplanner
set Arr[3]=webcomponents

set INSTALL=0
set _install=N
set /p _install="> Run npm install? (y/N): "
if %_install%==y set INSTALL=1
if %_install%==Y set INSTALL=1

set UPDATE=0
set _update=Y
set /p _update="> Run npm update? (Y/n): "
if %_update%==y set UPDATE=1
if %_update%==Y set UPDATE=1

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
set x=0

:SymLoop
if defined Arr[%x%] (
    call set MODULE=%%Arr[%x%]%%
    call echo ####################################################################
    call echo SETTING UP %%MODULE%%
    call echo ####################################################################
    call cd %%MODULE%%

    if exist .\dist\ (
        call echo - Deleting dist folder...
        call rimraf .\dist
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