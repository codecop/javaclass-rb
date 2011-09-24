# Example usage of the ClassScanner facility. Use the imported_3rd_party_types method
# to find all imported classes of a codebase. 
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib')
require 'javaclass/dsl/dsl'

# Return all types in this classpath _cp_
def own_types(cp)
  cp.names.collect { |c| c.full_name }.sort
end

# Determine all foreign imported types from all classes of a _cp_ 
def imported_types(cp)
  cp.values.collect { |clazz| clazz.imported_3rd_party_types }.flatten.uniq.sort - own_types(cp)
end

# TODO document this

base_path = 'E:\InArbeit\Kopie_Dropbox_NichtAendern\xbean\xbean-finder'

puts '---------- used 3rd party types in production'
cp_prod = classpath(File.join(base_path, 'target/classes'))
own_prod = own_types(cp_prod)
used_prod = imported_types(cp_prod)
puts used_prod

puts '---------- used 3rd party types in tests (only)'
cp_test = classpath(File.join(base_path, 'target/test-classes'))
used_test = imported_types(cp_test) - own_prod - used_prod
puts used_test

# TODO CONTINUE 6 detect and read spring XML configs for third party types?
