# Example usage of the ClassScanner facility. Use the imported_3rd_party_types method
# to find all imported classes of a code base (a Classpath). 
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

workspace_location = 'E:\Develop\Java\CodeLib'

# 1) create a classpath
cp_prod = classpath(File.join(workspace_location, '..', 'classes'))
# 2) remember types defined on the classpath
defined_prod = cp_prod.types
# 3) collect external dependencies of all classes on the classpath
imported_prod = cp_prod.external_types
# 4) also collect all classes referenced from config files
hardcoded_prod = scan_config_for_class_names(workspace_location).reject { |c| c.in_jdk? }
# TODO clumsy, improve scanner, then use agains
puts '---------- used 3rd party types in production'
used_prod = (imported_prod + hardcoded_prod - defined_prod).uniq.sort 
puts used_prod

cp_test = classpath(File.join(workspace_location, 'classes'))
imported_test = cp_test.external_types - defined_prod - used_prod
puts '---------- used 3rd party types in tests (only)'
puts imported_test
