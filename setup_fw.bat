@echo off

ipconfig|find/i "vpn_primavera" || rasdial vpn_primavera
echo.

set Arr[0]=services
set Arr[1]=localization
set Arr[2]=components
set Arr[3]=search
set Arr[4]=ngcore
set Arr[5]=pushnotifications
set Arr[6]=attachments
set Arr[7]=dashboard
set Arr[8]=extensibility
set Arr[9]=notifications
set Arr[10]=printing
set Arr[11]=qbuilder
set Arr[12]=shell
set Arr[13]=client-app-core

set INSTALL=0
set _install=Y
set /p _install="> Run npm install? (Y/n): "
if %_install%==y set INSTALL=1
if %_install%==Y set INSTALL=1

set FORCE=0
set _force=N
set PRI_ONLY=1
set _pri_only=Y
if %INSTALL% EQU 1 (
    @REM set _force=Y
    call set /p _force="> Force npm install? (y/N): "

    @REM set _pri_only=Y
    call set /p _pri_only="> Reinstall @primavera/@prototype only? (Y/n): "
)
if %_force%==y call set FORCE=1
if %_force%==Y call set FORCE=1
if %_pri_only%==n call set PRI_ONLY=0
if %_pri_only%==N call set PRI_ONLY=0

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
            call echo - Installing only @primavera/@prototype dependencies...
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

    if %LINT% EQU 1 (
        if exist .\node_modules\ (
            call echo - Running lint...
            call npm run lint
        )
    ) 
     
    if %BUILD% EQU 1 (
        if exist .\node_modules\ (
            call echo - Building...
            if %x% EQU 13 (
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