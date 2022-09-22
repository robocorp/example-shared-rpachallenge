@echo off
pushd .

SET SHARED_REPOSITORY=https://github.com/robocorp/example-shared-code-common
SET SHARED_DIRECTORY_NAME=shared

SET scriptPath=%~dp0
SET scriptPath=%scriptPath:~0,-1%
cd /D %scriptPath%

set /P version="Select package version ['X.Y.Z' OR empty to quit]: "
IF "%version%"=="" goto :END

if not exist "%SHARED_DIRECTORY%\" (
    echo Retrieving Shared repository version %version% ...
    git subtree add --prefix shared %SHARED_REPOSITORY% %version% --squash || goto :ERROR_BRANCH
    goto :PRINT_VERSION
) else (
    echo Updating to Shared repository version %version% ...
    git subtree pull --prefix shared %SHARED_REPOSITORY% %version% --squash || goto :ERROR_BRANCH
)
goto :PRINT_VERSION


:PRINT_VERSION
rem echo version.txt & type shared\version.txt
goto :END

:ERROR_BRANCH
echo Error! Git branch '%version%' does not exist or no access to repository
goto :END

:END
set scriptPath=
pause
popd
