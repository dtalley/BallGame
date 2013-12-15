cd..
set CWD=%~dp0
set PAUSE_ERRORS=1
call "%CWD%bat\SetupSDK.bat"
call "%CWD%bat\SetupApplication.bat"

:: Generate
echo.
echo Checking certificate...
call adt -checkstore -storetype pkcs12 -keystore %CERT_FILE% -storepass %CERT_PASS%
if errorlevel 1 goto failed

:succeed
echo.
echo Certificate validated.
echo.
goto end

:failed
echo.
echo Certificate is invalid!
echo.

:end
pause