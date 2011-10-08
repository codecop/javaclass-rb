call git clone git://github.com/relevance/rcov.git
cd rcov
call ruby setup.rb all --without-ext
call rcov
cd ..
rmdir /S /Q rcov
