# add the lib to the load path because it's not installed
$:.unshift File.join(File.dirname(__FILE__), 'lib')

if __FILE__ == $0
  
  require 'javaclass'
  
  clazz = JavaClass.parse('test/data/PublicClass.class')
  puts clazz.version                        # => 50.0
  puts clazz.constant_pool.items[1]         # => packagename/PublicClass
  puts clazz.accessible?                    # => true 
  
end

puts "finished"
