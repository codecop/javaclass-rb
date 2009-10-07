if exist JarClasspathTest*.* del JarClasspathTest*.*

md JarClasspathTestFolder\package
copy ClassVersionTest10.class JarClasspathTestFolder
copy ClassVersionTest11.class JarClasspathTestFolder\package

cd JarClasspathTestFolder
jar -cf ..\JarClasspathTest.jar .
cd ..

call winzip -a JarClasspathTest.zip ClassVersionTest10.class

echo Class-Path: JarClasspathTest.jar > manifest.txt
jar -cfm JarClasspathTestManifest.jar manifest.txt ClassVersionTest11.class
del manifest.txt

echo Version: 1.0.0> manifest.txt
echo Main-Class: at.kugel.tool.disconnect.Main>> manifest.txt
echo Class-Path: lib/httpunit-1.6.2.jar lib/nekohtml-0.9.1.jar             >> manifest.txt
echo    lib/xercesImpl-2.5.jar lib/js-1.5R4.1.jar>> manifest.txt
jar -cfm JarClasspathTestMultiManifest.jar manifest.txt ClassVersionTest11.class
del manifest.txt

pause
