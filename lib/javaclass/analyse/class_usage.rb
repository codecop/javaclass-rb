# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))

require 'javaclass'
include JavaClass

# Determine the imported types from all classes of a _classpath_ .
def imported_types(classpath)
  own_classes = classpath.names.collect { |c| c.full_name }.sort

  imported = classpath.names.collect do |name|
    clazz = load_cp(name, classpath)
    clazz.references.used_classes.collect { |c| c.full_name }
  end.flatten.uniq.sort

  imported.reject { |name| in_jdk?(name) } - own_classes
end

if __FILE__ == $0

  if ARGV.size < 2
    puts "#{__FILE__} <base folder> <test folder>"
    exit
  end

  cp = classpath("./target/classes")
  own = cp.names.collect { |c| c.full_name }.sort

  puts "---------- used types"
  used = imported_types(cp)
  puts used

  test_cp = classpath("./target/test-classes")

  puts "---------- for tests"
  test = imported_types(test_cp) - own - used
  puts test

  # TODO detect and read spring XML configs?

end