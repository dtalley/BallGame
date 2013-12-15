set CWD=%~dp0
call signtool.exe sign /f "%CWD%bat\ai_air_cert.p12" /p redhot12 "%CWD%air\FY14AIPresentation\FY14AIPresentation.exe"