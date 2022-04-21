@echo off
pushd .

SET scriptPath=%~dp0
SET scriptPath=%scriptPath:~0,-1%
cd /D %scriptPath%

set /P version="Select package version ['X.Y.Z' OR empty to quit]: "
IF "%version%"=="" goto :END

for /f %%a in ('git config -f .gitmodules submodule.modules.branch') do set "previous_version=%%a"
IF "%previous_version%"=="" (goto :INIT_MODULES) else (goto :CONTINUE)

:INIT_MODULES
echo Updating to Shared version %version% ...
git subtree add --prefix shared https://github.com/robocorp/example-shared-code-common %version% --squash || goto :ERROR_BRANCH
goto :PRINT_VERSION

:CONTINUE
echo Updating to Emerson Common package version %version% ...
git subtree pull --prefix shared https://github.com/robocorp/example-shared-code-common %version% || goto :ERROR_BRANCH

goto :PRINT_VERSION

:PRINT_VERSION
rem echo version.txt & type shared\version.txt
echo LOL
goto :END

:ERROR_BRANCH
echo Error! Git branch '%version%' does not exist or no access to repository
IF "%previous_version%"=="" (goto end) else (git subtree set-branch --branch %previous_version% modules)
goto :END

:END
set scriptPath=
pause
popd