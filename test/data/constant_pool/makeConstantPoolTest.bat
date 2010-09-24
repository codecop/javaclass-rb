if exist ConstantPoolTest.class del ConstantPoolTest.class

javac -g:none ConstantPoolTest.java
javap -verbose -private ConstantPoolTest

pause
