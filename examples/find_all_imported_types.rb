# Example usage of the ClassScanner facility. Use the imported_3rd_party_types method
# to find all imported classes of a code base (a Classpath). 
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

base_path = 'E:\InArbeit\Kopie_Dropbox_NichtAendern\xbean\xbean-finder'

puts '---------- used 3rd party types in production'
# 1) create a classpath
cp_prod = classpath(File.join(base_path, 'target/classes'))
# 2) remember all types in this classpath
own_prod = cp_prod.types
# 3) collect their external dependencies
used_prod = cp_prod.external_types
# TODO CONTINUE 9 - add hardcoded class name finder as in Java, use for Spring, plugin.xml
# detect and read spring XML configs to find used third party types?
puts used_prod

puts '---------- used 3rd party types in tests (only)'
cp_test = classpath(File.join(base_path, 'target/test-classes'))
used_test = cp_test.external_types - own_prod - used_prod
puts used_test

