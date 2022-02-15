@echo off

ipconfig|find/i "vpn_primavera" || rasdial vpn_primavera
echo.

set Arr[0]=services
set Arr[1]=localization
set Arr[2]=themes
set Arr[3]=components
set Arr[4]=search
set Arr[5]=ngcore
set Arr[6]=pushnotifications
set Arr[7]=attachments
set Arr[8]=dashboard
set Arr[9]=extensibility
set Arr[10]=notifications
set Arr[11]=printing
set Arr[12]=qbuilder
set Arr[13]=shell
set Arr[14]=client-app-core

set INSTALL=0
set _install=N
set /p _install="> Run npm install? (y/N): "
if %_install%==y set INSTALL=1
if %_install%==Y set INSTALL=1

set UPDATE=1
set _update=Y
set /p _update="> Run npm update? (Y/n): "
if %_update%==n set UPDATE=0
if %_update%==N set UPDATE=0

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

        call npm link @primavera/themes
    )

    if %UPDATE% EQU 1 (
        call echo - Running npm update...
        call npm update
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
            if %x% EQU 14 (
                call npm run build
            ) else (
                call npm run build:dev
            )
        )
    ) 
    
    call cd ..
    set /a x+=1
    goto :SymLoop
)
echo.
set /p=DONE! Hit ENTER to exit...