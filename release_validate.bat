@cls
call rake clean clobber

@rem see if the code is finished
call rake -f rake_analysis.rb todo
@echo ===== open todos ok?
@pause

@rem see if the code works as expected
call rake validate_gem test rcov
start coverage/index.html
@echo ===== test and coverage ok?
@pause

@rem see if the code is complex
call rake -f rake_analysis.rb
start complexity/index_cyclo.html 
@echo ===== complexity ok?
@pause

@rem validate the documentation
call rake fix_rdoc
start html\index.html
@echo ===== RDOC ok?
@pause

@rem validate the package
@setlocal
@for /F "usebackq" %%a in (`call rake version`) do set VERS=%%a
call rake package
cd pkg\javaclass-%VERS%
call rake test
@echo ===== packaged test ok?
@pause

call rake rdoc
start html\index.html
@echo ===== packaged RDOC ok?
@cd ..\..
@endlocal
@pause

call rake clean clobber
call rake -f rake_analysis.rb clean clobber
