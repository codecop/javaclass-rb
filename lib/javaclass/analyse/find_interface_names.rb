# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))

require 'javaclass/dsl/dsl'

if __FILE__ == $0

  if ARGV.empty?
    puts "#{File.basename(__FILE__)} <project base folder>"
    puts "scan all Java cass files in the workspace and find interface names."
    exit
  end

  matcher = /^com\.ibm\.arc\.sdm/
    
  # add an Eclipse classpath variable
  # JavaClass::Classpath::EclipseClasspath::add_variable('KOR_HOME', 'E:\Develop\Java')

  cp = workspace(ARGV[0])
  puts "#{cp.elements.size} classpaths found in the workspace:\n  #{cp.elements.join("\n  ")}"
  puts "#{cp.count} classes found in classpath"
  puts "#{cp.names { |clazz| clazz.package =~ matcher }.size} classes matched #{matcher}"
  
  names = cp.values { |clazz| clazz.package =~ matcher  }.
             find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }.
             collect { |clazz| clazz.name.simple_name } 
  puts "#{names.size} interfaces found:\n  #{names.sort.join("\n  ")}"

  inames = names.find_all { |name| name =~ /^I[A-Z]/ }
  puts "#{inames.size} interfaces start with I:\n  #{inames.join("\n  ")}"
  
end
