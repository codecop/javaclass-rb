if exist JavaHomeClasspathTest\nul rmdir /S /Q JavaHomeClasspathTest

md JavaHomeClasspathTest\jdk\jre\lib
jar -cf JavaHomeClasspathTest\jdk\jre\lib\rt.jar ..\class_version\ClassVersionTest10.class

md JavaHomeClasspathTest\jre\lib
jar -cf JavaHomeClasspathTest\jre\lib\rt.jar ..\class_version\ClassVersionTest10.class

md JavaHomeClasspathTest\jre-ext\lib\ext
jar -cf JavaHomeClasspathTest\jre-ext\lib\rt.jar ..\class_version\ClassVersionTest10.class
jar -cf JavaHomeClasspathTest\jre-ext\lib\ext\ext.jar ..\class_version\ClassVersionTest11.class

pause
