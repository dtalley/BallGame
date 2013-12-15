set CWD=%~dp0
call "C:\Program Files (x86)\Windows Kits\8.0\bin\x64\signtool.exe" sign /f "%CWD%bat\ai_air_cert.p12" /p redhot12 "%CWD%..\installer\fy14aipresentationinstaller.msi"
pause