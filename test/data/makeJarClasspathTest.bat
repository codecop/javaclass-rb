if exist JarClasspathTest*.* del JarClasspathTest*.*

md JarClasspathTestFolder
copy ClassVersionTest10.class JarClasspathTestFolder

jar -cf JarClasspathTest.jar ClassVersionTest10.class

call winzip -a JarClasspathTest.zip ClassVersionTest10.class

echo Class-Path: JarClasspathTest.jar > manifest.txt
jar -cfm JarClasspathTestManifest.jar manifest.txt ClassVersionTest11.class
del manifest.txt

pause
