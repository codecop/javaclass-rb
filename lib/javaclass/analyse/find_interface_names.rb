# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))

require 'javaclass/dsl'

if __FILE__ == $0

  if ARGV.empty?
    puts "#{File.basename(__FILE__)} <project base folder>"
    puts "scan all Java cass files recursively and find interface names."
    exit
  end

  cp = workspace(ARGV[0])
  names = cp.values { |clazz| clazz.package =~ /^com\.ibm\.arc\.sdm/  }.
             find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }.
             collect { |clazz| clazz.name.simple_name } 
  puts names.sort
  # TODO CONTINUE 9 check all interfaces how they are named, upgrade DSL to have this as simple as possible

end
