@echo off

set yes=(Y/n)
set no=(y/N)

set DEL_DIST=0
set _del_dist=Y
IF %_del_dist%==Y set del_dist_choice=%yes%
IF %_del_dist%==N set del_dist_choice=%no%
IF exist .\dist\ (
    set /p _del_dist="> Delete dist folder? %del_dist_choice%: "
) ELSE (
    set _del_dist=N
)
if %_del_dist%==y set DEL_DIST=1
if %_del_dist%==Y set DEL_DIST=1

set INSTALL=0
set _install=N
IF %_install%==Y set install_choice=%yes%
IF %_install%==N set install_choice=%no%
set /p _install="> Run npm install? %install_choice%: "
IF %_install%==Y set INSTALL=1
IF %_install%==y set INSTALL=1

set FORCE=0
set _force=N
IF %_force%==Y set force_choice=%yes%
IF %_force%==N set force_choice=%no%
set PRI_ONLY=0
set _pri_only=N
IF %_pri_only%==Y set pri_only_choice=%yes%
IF %_pri_only%==N set pri_only_choice=%no%
IF %INSTALL% EQU 1 (
    set /p _force="> Force npm install? %force_choice%: "
    set /p _pri_only="> Reinstall PRIMAVERA/PROTOTYPE dependencies only? %pri_only_choice%: "
) ELSE (
    set _force=N
    set _pri_only=N
)
IF %_force%==Y set FORCE=1
IF %_force%==y set FORCE=1
IF %_pri_only%==Y set PRI_ONLY=1
IF %_pri_only%==y set PRI_ONLY=1

set UPDATE=0
set _update=N
IF %_update%==Y set update_choice=%yes%
IF %_update%==N set update_choice=%no%
if %INSTALL% EQU 0 (
    set /p _update="> Run npm update? %update_choice%: "
) ELSE (
    set _update=N
)
if %_update%==y set UPDATE=1
if %_update%==Y set UPDATE=1

@REM set LINK=0
@REM set _link=N
@REM IF %_link%==Y set link_choice=%yes%
@REM IF %_link%==N set link_choice=%no%
@REM set /p _link="> Link modules for debug? %link_choice%: "
@REM if %_link%==y set LINK=1
@REM if %_link%==Y set LINK=1

set LINT=0
set _lint=N
IF %_lint%==Y set lint_choice=%yes%
IF %_lint%==N set lint_choice=%no%
set /p _lint="> Perform Linting? %lint_choice%: "
if %_lint%==y set LINT=1
if %_lint%==Y set LINT=1

set BUILD=0
set _build=N
IF %_build%==Y set build_choice=%yes%
IF %_build%==N set build_choice=%no%
set /p _build="> Build? %build_choice%: "
if %_build%==y set BUILD=1
if %_build%==Y set BUILD=1

set DEL_COVERAGE=0
set _del_coverage=Y
IF %_del_coverage%==Y set del_coverage_choice=%yes%
IF %_del_coverage%==N set del_coverage_choice=%no%
IF exist .\.coverage\ (
    set /p _del_coverage="> Delete .coverage folder? %del_coverage_choice%: "
) ELSE (
    set _del_coverage=N
)
if %_del_coverage%==y set DEL_COVERAGE=1
if %_del_coverage%==Y set DEL_COVERAGE=1

set TEST=0
set _test=N
IF %_test%==Y set test_choice=%yes%
IF %_test%==N set test_choice=%no%
set /p _test="> Run unit tests? %test_choice%: "
if %_test%==y set TEST=1
if %_test%==Y set TEST=1

FOR /F "tokens=*" %%g IN ('npm list -g --depth=0 rimraf') DO (SET rimraf_status=%%g)
if "x%rimraf_status:rimraf=%" == "x%rimraf_status%" (
    call echo.
    call echo - Installing rimraf globally...
    call npm i -g rimraf
)

echo.

IF exist .\.angular\ GOTO Setup
IF %DEL_DIST% EQU 1 GOTO Setup
IF %DEL_COVERAGE% EQU 1 GOTO Setup
IF %INSTALL% EQU 1 GOTO Setup
IF %UPDATE% EQU 1 GOTO Setup
IF %LINT% EQU 1 GOTO Setup
IF %BUILD% EQU 1 GOTO Setup
@REM IF %LINK% EQU 1 GOTO Setup
IF %TEST% EQU 1 GOTO Setup
GOTO END

:Setup
    call echo ####################################################################
    call echo SETTING UP ClientApp
    call echo ####################################################################

    if exist .\.angular\ (
        call echo - Deleting .angular folder...
        call rimraf .\.angular
    )

    if %DEL_DIST% EQU 1 (
        if exist .\dist\ (
            call echo - Deleting dist folder...
            call rimraf .\dist
        )
    )

    if %DEL_COVERAGE% EQU 1 (
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

        IF %PRI_ONLY% EQU 1 (
            IF EXIST .\node_modules\@primavera (
                CALL echo - Deleting @primavera folder...
                CALL rimraf .\node_modules\@primavera
            )
            IF EXIST .\node_modules\@prototype (
                CALL echo - Deleting @prototype folder...
                CALL rimraf .\node_modules\@prototype
            )

            IF %FORCE% EQU 1 (
                CALL echo - Installing only PRIMAVERA/PROTOTYPE dependencies in forced mode...
            ) ELSE (
                CALL echo - Installing only PRIMAVERA/PROTOTYPE dependencies...
            )
        ) ELSE (
            IF EXIST .\node_modules\ (
                CALL echo - Deleting node_modules folder...
                CALL rimraf .\node_modules
            )

            IF %FORCE% EQU 1 (
                CALL echo - Installing dependencies in foced mode...
            ) ELSE (
                CALL echo - Installing dependencies...
            )
        )
        
        CALL npm cache clean --force --silent
        
        IF %FORCE% EQU 1 (
            CALL npm i --force --silent
        ) ELSE (
            CALL npm i --silent
        )
    )

    if %UPDATE% EQU 1 (
        call echo - Running npm update...
        call npm cache clean --force
        call npm update
        
        call echo.
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

    @REM if %LINK% EQU 1 (
    @REM     CALL echo - Linking modules for debug
    @REM     CALL npm run link:modules --silent
    @REM )

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

:END
echo FINISHED
echo.


@REM  *Review date: 20/07/2023*
@REM  *Tiago Eusébio @ TOEC*
@REM  *© Cegid*
