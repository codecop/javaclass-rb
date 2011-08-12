# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))

require 'javaclass'
include JavaClass

if __FILE__ == $0

  if ARGV.empty?
    puts "#{__FILE__} <base folder>"
    puts "scan all Java cass files recursively and find interface names."
    exit
  end

  cp = classpath(ARGV[0])
  puts cp.names.collect { |name| load_cp(name, cp) }.find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }
  # TODO check all interfaces how they arenamed,
end