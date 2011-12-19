call rake clean clobber

rem see if the code is finished
call rake todo
echo open todos ok?
pause

rem see if the code works as expected
call rake validate_gem test rcov
echo test and coverage ok?
pause

rem validate the documentation
call rake fix_rdoc
start html\index.html
echo RDOC ok?
pause

rem validate the package
for /F "usebackq" %%a in (`call rake version`) do set VERS=%%a
call rake package
cd pkg\javaclass-%VERS%
call rake test
echo packaged test ok?
pause

call rake rdoc
start html\index.html
echo packaged RDOC ok?
cd ..\..
set VERS=
pause

call rake clean clobber
cls
