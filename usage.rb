# add the lib to the load path because it's not installed
$:.unshift File.join(File.dirname(__FILE__), 'lib')

if __FILE__ == $0
  
  require 'javaclass'

  # load a class directly from the file system
  clazz = JavaClass.load_fs('test/data/access_flags/AccessFlagsTestPublic.class')
  
  # or look up the class from some classpath by its Java qualified name
  cp = JavaClass.classpath('test/data/access_flags')
  clazz = JavaClass.load_cp('AccessFlagsTestPublic', cp)
  
  puts clazz.version                          # => 50.0
  puts clazz.constant_pool.items[1]           # => packagename/AccessFlagsTestPublic
  puts clazz.access_flags.public?             # => true
  puts clazz.this_class                       # => packagename/AccessFlagsTestPublic
  puts clazz.this_class.to_java_file          # => packagename/AccessFlagsTestPublic.java
  puts clazz.super_class                      # => java/lang/Object
  puts clazz.super_class.to_classname         # => java.lang.Object
  puts clazz.references.referenced_methods[0] # => java/lang/Object.<init>:()V
  
  # or get a class from the system classpath
  cp = JavaClass.environment_classpath        # needs JAVA_HOME to be set
  puts cp.includes?('java.lang.String')       # => true
  data = cp.load_binary('java.lang.String')
  clazz = JavaClass.disassemble(data)
  puts clazz.name                             # => "java.lang.String"
  puts clazz.access_flags.final?              # => true
  puts clazz.interfaces                       # => ["java/io/Serializable", "java/lang/Comparable", "java/lang/CharSequence"]
  
end

puts "finished"
