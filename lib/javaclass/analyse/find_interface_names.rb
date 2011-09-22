# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))

require 'javaclass/dsl'

if __FILE__ == $0

  if ARGV.empty?
    puts "#{File.basename(__FILE__)} <project base folder>"
    puts "scan all Java cass files in the workspace and find interface names."
    # exit
  end
  
  # add an Eclipse classpath variable
  JavaClass::Classpath::EclipseClasspath::add_variable('KOR_HOME', 'E:\Develop\Java')

  cp = workspace('E:\Develop\Java') # ARGV[0])
  puts "classpaths found in the workspace:\n#{cp.elements.join("\n")}"
  
  names = cp.values { |clazz| clazz.package =~ /^at\.kugel\./ }.# /^com\.ibm\.arc\.sdm/  }.
             find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }.
             collect { |clazz| clazz.name.simple_name } 
  
  puts names.sort
  # TODO CONTINUE 9 check all interfaces how they are named, upgrade DSL to have this as simple as possible

end
