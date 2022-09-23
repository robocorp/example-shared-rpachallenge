@ECHO OFF
PUSHD .

SET scriptPath=%~dp0
SET scriptPath=%scriptPath:~0,-1%
CD /D %scriptPath%

REM TODO. output somehow the tag currently in use. git tag ?
REM TODO. need to verify that version is correct
SET /P release="Set release version ['X.Y.Z' or empty for no release]: "
IF "%release%"=="" goto :END

SET releasetext=Release %release% for Shared Code Common

echo %release% > version.txt
git add version.txt
git commit -m "%releasetext%"
git push
git tag -a %release% -m "%releasetext%"
git push origin refs/tags/%release%

:END
SET scriptPath=

POPD
