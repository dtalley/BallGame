set PAUSE_ERRORS=1
set CWD=%~dp0
call "%CWD%bat\SetupSDK.bat"
call "%CWD%bat\SetupApplication.bat"

set AIR_TARGET=
::set AIR_TARGET=-captive-runtime
set OPTIONS=
call "%CWD%bat\Packager.bat"

pause