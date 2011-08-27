# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))

require 'javaclass'
include JavaClass

# Determine the imported types from all classes of a _cp_ .
def imported_types(cp)
  own_classes = cp.names.collect { |c| c.full_name }.sort

  imported = cp.names.collect do |name|
    clazz = load_cp(name, cp)
    clazz.references.used_classes.collect { |c| c.full_name }.reject { |name| in_jdk?(name) }
  end.flatten.uniq.sort

  imported - own_classes
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