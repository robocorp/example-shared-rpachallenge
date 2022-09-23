@echo off
pushd .
SETLOCAL ENABLEDELAYEDEXPANSION
SET SHARED_REPOSITORY=https://github.com/robocorp/example-shared-code-common
SET SHARED_DIRECTORY=shared

SET scriptPath=%~dp0
SET scriptPath=%scriptPath:~0,-1%
cd /D %scriptPath%

FOR /F "tokens=* USEBACKQ" %%F IN (`git diff-files`) DO (
    IF NOT "%%F" == "" goto :ERROR_CHANGES
)


echo Current version & type %SHARED_DIRECTORY%\version.txt
set /P version="Select package version ['X.Y.Z' OR empty to quit]: "
IF "%version%"=="" goto :END

if not exist "%SHARED_DIRECTORY%\" (
    echo Retrieving common libraries version: %version% ...
    git subtree add --prefix %SHARED_DIRECTORY% %SHARED_REPOSITORY% %version% --squash || goto :ERROR_BRANCH
    goto :PRINT_VERSION
) else (
    echo Updating common libraries to version: %version% ...
    git subtree pull --prefix %SHARED_DIRECTORY% %SHARED_REPOSITORY% %version% --squash || goto :ERROR_BRANCH
)
goto :PRINT_VERSION


:PRINT_VERSION
echo Updated to version & type %SHARED_DIRECTORY%\version.txt
goto :END

:ERROR_CHANGES
echo Error! You have uncommitted changes, please commit or stash before updating common libraries.
goto :END


:ERROR_BRANCH
echo Error! Could not find '%version%' in common libraries repository: %SHARED_REPOSITORY%
goto :END

:END
set scriptPath=
pause
ENDLOCAL
popd
