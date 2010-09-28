# add the lib to the load path
$:.unshift File.join(File.dirname(__FILE__), 'lib')

# TODO cleanup this code fragment and make a proper class 

require 'javaclass'
include JavaClass

def process_class(name, already=[], intend=0)
  file_name = 'C:\JavaDev\classes\\' + name.gsub(/\./,'\\') + '.class'
  return if !FileTest.exist? file_name
  # p file_name
  clazz = JavaClass.parse(file_name)
  # p clazz
  puts " "*intend + clazz.this_class
  
  imported = clazz.references.used_classes.collect { |c| c.to_s }.sort
  new_used = imported - already
  already << new_used
  already.flatten!
  new_used.find_all { |c| c =~ /at\/spardat\// }.each do |c|
    process_class(c, already, intend+1)
  end
end

def process_package(folder, already=[], intend=0)
  file_name = 'C:\JavaDev\classes\\' + folder.gsub(/\./,'\\')
  cwd = Dir.getwd
  Dir.chdir file_name
  files = Dir['*']
  files.each do |c|
    if c =~ /\.class$/
      process_class(folder + '.' + c[/^[^.]+/], already, intend)
    elsif FileTest.directory? c
      puts " "*intend+ '-----'
      process_package(folder + '.' + c, already, intend)
    end
  end
  Dir.chdir cwd
end

# total = []
# #process_class('at/spardat/krimiaps/service/client/service/impl/ClientSmeSearchServiceImpl', total)
# #process_class('at/spardat/krimiaps/service/client/service/impl/ClientPrivateSearchServiceImpl', total)
#
# # --- common
# #process_package('at.spardat.krimicee.common', total) #
# #process_package('at.spardat.krimiaps.common', total) # -> 79 ok
# #process_package('at.spardat.common', total) # 146, in sich, koennte nach common
# #process_package('at.spardat.integrator', total) #
# # DatabaseAwareComponent -> ganze DB
# #process_package('at.spardat.krimicee.util', total)
# # ItoTestApsSchema -> ganze DB
# # process_package('at.spardat.krimicee.lib', total)
# # KrimiLock -> ganze DB
#
# #process_package('at.spardat.krimicee.dom', total)
# #process_package('at.spardat.krimicee.db', total)
# # KrimiLoanService, PrintHelper ->
# #process_package('at.spardat.krimicee.dao', total)
# #process_package('at.spardat.krimicee.dao', total)
# #process_package('at.spardat.krimicee.entity', total)
# #process_package('at.spardat.krimicee.entity', total)
# #process_package('at.spardat.krimicee.eo', total)
# #process_package('at.spardat.krimicee.sql', total)
# #process_package('at.spardat.krimicee.model', total) # 1647
#
# puts total.size
