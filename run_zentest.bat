@echo off
cls
setlocal
set RUBYLIB=%RUBYLIB%;.\lib
for /f %%a in ('dir /b lib\javaclass\*.rb') do if exist test\test_%%a call zentest lib\javaclass\%%a test\test_%%a
endlocal
pause
