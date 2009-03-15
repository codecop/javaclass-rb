@echo off
setlocal
set RUBYLIB=%RUBYLIB%;.\lib
for /f %%a in ('dir /b lib\javaclass\*.rb') do if exist test\tc_%%a call zentest lib\javaclass\%%a test\tc_%%a
endlocal
pause
