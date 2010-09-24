if exist ClassVersionTest*.class del ClassVersionTest*.class

setlocal

call profile102
javac -classpath %CLASSPATH% ClassVersionTest.java
ren ClassVersionTest.class ClassVersionTest10.class

call profile118
javac -classpath %CLASSPATH% ClassVersionTest.java
ren ClassVersionTest.class ClassVersionTest11.class

call profile122
javac -target 1.2 ClassVersionTest.java
ren ClassVersionTest.class ClassVersionTest12.class

call profile131
javac -target 1.3 ClassVersionTest.java
ren ClassVersionTest.class ClassVersionTest13.class

call profile141
javac -target 1.4 ClassVersionTest.java
ren ClassVersionTest.class ClassVersionTest14.class

call profile150
javac ClassVersionTest.java
ren ClassVersionTest.class ClassVersionTest15.class

call profile160
javac ClassVersionTest.java
ren ClassVersionTest.class ClassVersionTest16.class

endlocal

pause
