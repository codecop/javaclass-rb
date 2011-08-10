# add the lib to the load path
$:.unshift File.join(File.dirname(__FILE__), 'lib')

# TODO cleanup this code fragment and make a proper class 

require 'javaclass'
include JavaClass

# TODO move this list to its own file (yaml?)
JDK_PACKAGES = %w| java javax.accessibility javax.activity javax.crypto javax.imageio javax.jnlp javax.management 
                   javax.naming javax.net javax.print javax.rmi javax.script javax.security.auth javax.security.cert
                   javax.security.sasl javax.sound.midi javax.sound.sampled javax.sql javax.swing javax.transaction
                   javax.xml org.ietf.jgss org.w3c.dom org.xml.sax|.collect { |pkg| /^#{pkg}\./ }
                     
def in_jdk?(name)
  JDK_PACKAGES.find { |regex| name =~ regex } != nil
end                     

def imported_types(classes)
  own_classes = classes.names.collect { |name| name.gsub('/', '.').sub(/\.class$/, '')}.sort 
  
  imported = classes.names.collect do |name|
    clazz = JavaClassHeader.new(classes.load_binary(name))
    clazz.references.used_classes.collect { |c| c.to_s.gsub('/', '.') }  
  end.flatten.uniq.sort
  
  imported.reject { |name| in_jdk?(name) } - own_classes
end

# TODO detect and read spring XML configs?

classes = JavaClass::Classpath::FolderClasspath.new("./target/classes")
own = classes.names.collect { |name| name.gsub('/', '.').sub(/\.class$/, '')}.sort
used = imported_types(classes)
puts "---------- used types" 
puts used

test_classes = JavaClass::Classpath::FolderClasspath.new("./target/test-classes")
test = imported_types(test_classes) - own - used 
puts "---------- for tests" 
puts test

