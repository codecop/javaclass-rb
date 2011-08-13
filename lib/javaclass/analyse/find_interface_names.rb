# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))

require 'javaclass'
require 'javaclass/dsl'
include JavaClass
include JavaClass::Dsl

if __FILE__ == $0

  if ARGV.empty?
    puts "#{File.basename __FILE__} <base folder>"
    puts "scan all Java cass files recursively and find interface names."
    exit
  end

  cp = classpath(ARGV[0])
  puts cp.names.collect { |name| load_cp(name, cp) }.find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }
  # TODO check all interfaces how they arenamed,
    
end