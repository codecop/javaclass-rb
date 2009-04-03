if exist AccessFlagsTest*.class del AccessFlagsTest*.class

md classes
javac -d classes AccessFlagsTest*.java

copy classes\packagename\*.class .

rmdir /S /Q classes
pause
