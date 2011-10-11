# Example of simple usage of JavaClass to load and inspect class files. 
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass'

# 1) load a class directly from the file system
clazz = JavaClass.load_fs('./test/data/access_flags/AccessFlagsTestPublic.class')

# or get a class from the system classpath which needs JAVA_HOME to be set
cp = JavaClass.environment_classpath        
puts cp.includes?('java/lang/String.class') # => 1 (true)

# or look up the class from some classpath by its Java qualified name
cp = JavaClass.classpath('./test/data/access_flags')
puts cp.includes?('AccessFlagsTestPublic')  # => 1 (true)
clazz = JavaClass.load_cp('AccessFlagsTestPublic', cp)
  
# 2) retrieve low level information about a class
puts clazz.version                          # => "50.0"
puts clazz.constant_pool.items[1]           # => "packagename/AccessFlagsTestPublic"
puts clazz.access_flags.public?             # => true
puts clazz.access_flags.final?              # => false
puts clazz.this_class                       # => "packagename/AccessFlagsTestPublic"
puts clazz.super_class                      # => "java/lang/Object"
puts clazz.super_class.to_classname         # => "java.lang.Object"
puts clazz.references.referenced_methods[0] # => "java/lang/Object.<init>:()V"
puts clazz.interfaces                       # => []

# 3) work with class names
puts clazz.this_class.to_java_file          # => "packagename/AccessFlagsTestPublic.java"
puts clazz.this_class.full_name             # => "packagename.AccessFlagsTestPublic"
puts clazz.this_class.package               # => "packagename"
puts clazz.this_class.simple_name           # => "AccessFlagsTestPublic"

# TODO CONTINUE 5 - create a script that creates the *.txt for the good examples from rb and includes them in rdoc 
# (this is in fact a rake task)
# add the links to them to readme.txt
