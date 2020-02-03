@cls

@call rake clean clobber
@setlocal
@rem ruby 187
@echo ================================================================================
@ruby -v
@call gem list rubyzip
@call rake
@endlocal
@pause

@call rake clean clobber
@setlocal
@call ..\Compiler\set_ruby_19_in_path
@echo ================================================================================
@ruby -v
@call gem list rubyzip
@call rake
@endlocal
@pause

@call rake clean clobber
@setlocal
@call ..\Compiler\set_ruby_20_in_path
@echo ================================================================================
@ruby -v
@call gem list rubyzip
@call rake
@endlocal
@pause

@call rake clean clobber
@setlocal
@call ..\Compiler\set_ruby_21_in_path
@echo ================================================================================
@ruby -v
@call gem list rubyzip
@call rake
@endlocal
@pause

@call rake clean clobber
@setlocal
@call ..\Compiler\set_ruby_26_in_path
@echo ================================================================================
@ruby -v
@call gem list rubyzip
@call rake
@endlocal
@pause
