@echo off

echo ********** deleting API repo and cloning new one **********
if exist api\nul rmdir /S /Q api
call hg clone https://api.javaclass-rb.googlecode.com/hg/ api
cd api

rem call E:\Tool\putty\pscp -r -pw kugel100 bruno41@rubyforge.org:/var/www/gforge-projects/javaclass/ .
rem if exist classes\nul rmdir /S /Q classes
rem if exist files\nul rmdir /S /Q files
rem if exist f_*.html del f_*.html

echo ********** update 'Readme_txt.html' **********
echo --------------------------
type ..\rdoc_page_changes.txt
echo --------------------------
call ued ..\..\html\files\Readme_txt.html
pause

echo ********** add new folder for API doc (as copy from 'html') **********

echo ********** update version in 'index.html' **********
call ued index.html
pause

call hg add
call hg st

echo ********** commit changes **********
pause
call hg ci -m "new version of API doc"

echo ********** push changes **********
pause
call hg push

pause
echo ********** deleting API repo **********
cd ..
if exist api\nul rmdir /S /Q api

pause
