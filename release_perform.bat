call rake clean clobber

rem update the versions
call ued javaclass.gemspec
call ued history.txt
echo version number and history ok?
pause
del javaclass.gemspec.bak
del history.txt.bak

rem commit the new version
call hg ci -m "prepare release, update version"
call rake tag
echo version and tag ok?
pause

rem publish gem 
call rake publish_gem
echo publish ok?
pause

rem publish doc
call rake publish_rdoc
start api\index.html
echo publish ok?

cd api
call hg push
cd ..
echo push ok?
pause

rem update the versions
call ued javaclass.gemspec
echo next version number and empty date ok?
pause
del javaclass.gemspec.bak

rem commit the new version
call hg ci -m "after release, update version"
echo version ok?
pause

call rake clean clobber