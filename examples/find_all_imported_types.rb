# Example usage of the ClassScanner facility. Use the imported_3rd_party_types method
# to find all imported classes of a code base (a classpath). 
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

location = 'E:\Develop\Java\CodeLib'

# 1) create a classpath
cp = classpath(File.join(location, '..', 'classes'))

# 2) remember types defined on the classpath
prod_classnames = cp.types

# 3) collect all dependencies of all classes on the classpath
imported_classnames = cp.used_types

# 4) also collect all classes referenced from config files
hardcoded_classnames = scan_config_for_3rd_party_class_names(location) 

puts '---------- used 3rd party types in production'
used_classnames = (imported_classnames + hardcoded_classnames).uniq.sort  - prod_classnames 
puts used_classnames

test_cp = classpath(File.join(location, 'classes'))
puts '---------- used 3rd party types in tests (only)'
test_classes = test_cp.external_types - prod_classnames - used_classnames
puts test_classes
