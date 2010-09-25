# add the lib to the load path because it's not installed
$:.unshift File.join(File.dirname(__FILE__), 'lib')

if __FILE__ == $0
  
  require 'javaclass'
  
  clazz = JavaClass.parse('test/data/access_flags/AccessFlagsTestPublic.class')
  puts clazz.version                          # => 50.0
  puts clazz.constant_pool.items[1]           # => packagename/AccessFlagsTestPublic
  puts clazz.access_flags.public?             # => true
  puts clazz.this_class                       # => packagename/AccessFlagsTestPublic
  puts clazz.super_class                      # => java/lang/Object
  puts clazz.references.referenced_methods[0] # => java/lang/Object.<init>:()V
  
end

puts "finished"
