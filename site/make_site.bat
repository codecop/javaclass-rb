cls

echo "recreating RDOC"
cd ..
call rake clobber_rdoc
call rake rdoc

echo "transferring site"
cd html
call E:\Tool\putty\pscp -r *.* bruno41@rubyforge.org:/var/www/gforge-projects/javaclass
call E:\Tool\putty\pscp -ls bruno41@rubyforge.org:/var/www/gforge-projects/javaclass

pause
