@echo off
cls
setlocal
set RUBYLIB=%RUBYLIB%;.\lib
for /f %%a in ('dir /b lib\javaclass\*.rb') do if exist test\test_%%a call zentest lib\javaclass\%%a test\test_%%a
for /f %%a in ('dir /b lib\javaclass\classpath\*.rb') do if exist test\test_%%a call zentest lib\javaclass\classpath\%%a test\test_%%a
endlocal
pause
