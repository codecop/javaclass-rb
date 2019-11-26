del *.jar

md classes
javac -d classes *.java
cd classes
jar -cf ..\JarClassListTest.jar *
cd ..

rem copy classes\packagename\*.class .

rmdir /S /Q classes
pause
