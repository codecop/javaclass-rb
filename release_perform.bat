call rake clean clobber

@rem update the versions
call ued javaclass.gemspec
call ued history.txt
@echo ===== version number and history ok?
@pause
del javaclass.gemspec.bak
del history.txt.bak

@rem commit the new version
call git commit -am "Prepare next release, update version number."
call rake tag
call git log --stat -n 3
@echo ===== tag with version ok?
@pause

@rem publish gem
@rem set HOME=%HOMEDRIVE%%HOMEPATH%
call rake publish_gem
@echo ===== publish to rubygem ok?
@pause

@rem publish zip
@echo upload zip und gem manually!
copy pkg\*.zip hosting\5_github.com\downloads\
copy pkg\*.gem hosting\5_github.com\downloads\
start https://www.code-cop.org/download/javaclass-rb/
@echo ===== manual upload ok?
@pause

@rem publish doc
call rake publish_rdoc
start api\index.html
@echo ===== generated rdoc ok?
@rem set HOME=
@pause

@rem publish api doc
echo upload newest API using FTP
echo ===== upload manually ok?
@pause

@rem update the versions
call ued javaclass.gemspec
@echo ===== next version number ok?
@pause
del javaclass.gemspec.bak

@rem commit the new version
call git commit -am "After release, update version number."
call git log --stat -n 2
@echo ===== commit ok?
@pause

call rake clean clobber
