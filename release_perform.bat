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
call hg log --stat -l3
echo tag mit version ok?
pause

rem publish gem
set HOME=%HOMEDRIVE%%HOMEPATH%
call rake publish_gem
echo publish to rubygem ok?
pause

rem publish zip
echo upload zip und gem manually!
copy pkg\*.zip E:\Develop\Ruby\JavaClass\hosting\4_bitbucket.org\downloads\
copy pkg\*.gem E:\Develop\Ruby\JavaClass\hosting\4_bitbucket.org\downloads\
start https://bitbucket.org/pkofler/javaclass-rb/downloads
echo manual upload ok?
pause

rem publish doc
call rake publish_rdoc
start api\index.html
echo publish to api repo ok?

cd api
call hg push
cd ..
set HOME=
echo push ok?
pause

rem publish api doc
echo upload newest API using FTP
echo upload manually ok?
pause

rem update the versions
call ued javaclass.gemspec
echo next version number ok?
pause
del javaclass.gemspec.bak

rem commit the new version
call hg ci -m "after release, update version"
call hg log --stat -l2
echo commit ok?
pause

call rake clean clobber
