# add the lib to the load path because it's not installed
$:.unshift File.join(File.dirname(__FILE__), 'lib')

if __FILE__ == $0
  
  require 'javaclass/dsl'

  # load a class directly from the file system
  clazz = JavaClass.load_fs('./test/data/access_flags/AccessFlagsTestPublic.class')
  
  # or look up the class from some classpath by its Java qualified name
  cp = JavaClass.classpath('./test/data/access_flags')
  puts cp.includes?('AccessFlagsTestPublic')  # => true
  clazz = JavaClass.load_cp('AccessFlagsTestPublic', cp)
    
  # retrieve low level information about a class
  puts clazz.version                          # => 50.0
  puts clazz.constant_pool.items[1]           # => packagename/AccessFlagsTestPublic
  puts clazz.access_flags.public?             # => true
  puts clazz.access_flags.final?              # => false
  puts clazz.this_class                       # => packagename/AccessFlagsTestPublic
  puts clazz.super_class                      # => java/lang/Object
  puts clazz.super_class.to_classname         # => java.lang.Object
  puts clazz.references.referenced_methods[0] # => java/lang/Object.<init>:()V
  p clazz.interfaces                          # => []

  # work with class names
  puts clazz.this_class.to_java_file          # => packagename/AccessFlagsTestPublic.java
  puts clazz.this_class.full_name             # => packagename.AccessFlagsTestPublic
  puts clazz.this_class.package               # => packagename
  puts clazz.this_class.simple_name           # => AccessFlagsTestPublic

  # or get a class from the system classpath
  # cp = JavaClass.environment_classpath        # needs JAVA_HOME to be set
  
end

puts "finished"
