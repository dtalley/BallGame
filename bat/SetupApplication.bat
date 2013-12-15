:user_configuration

:: About AIR application packaging
:: http://livedocs.adobe.com/flex/3/html/help.html?content=CommandLineTools_5.html#1035959
:: http://livedocs.adobe.com/flex/3/html/distributing_apps_4.html#1037515

:: NOTICE: all paths are relative to project root

:: Your certificate information
set CERT_NAME="Ball Game"
set CERT_PASS=redhot12
set CERT_FILE="%CWD%bat\ai_air_cert.p12"
set SIGNING_OPTIONS=-storetype pkcs12 -keystore %CERT_FILE% -storepass %CERT_PASS%

:: Application descriptor
set APP_XML="%CWD%application.xml"

:: Files to package
set APP_DIR="%CWD%bin"
set FILE_OR_DIR=-C %APP_DIR% BallGame.swf assets/textures/atlas_hd.png

:: Your application ID (must match <id> of Application descriptor)
set APP_ID=com.orionark.games.BallGame

:: Output
set AIR_PATH=air
set AIR_NAME=BallGame


:validation
%SystemRoot%\System32\find /C "<id>%APP_ID%</id>" %APP_XML% > NUL
if errorlevel 1 goto badid
goto end

:badid
echo.
echo ERROR: 
echo   Application ID in 'bat\SetupApplication.bat' (APP_ID) 
echo   does NOT match Application descriptor '%APP_XML%' (id)
echo.
if %PAUSE_ERRORS%==1 pause
exit

:end