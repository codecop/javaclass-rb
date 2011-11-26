# Example usage of the class analysis featuress of JavaClass::ClassScanner and JavaClass::Analyse. 
# After defining a classpath, use dependency analysis to find all used classes of a codebase. 
# This code uses in turn the method <i>imported_3rd_party_types</i> of 
# JavaClass::ClassScanner::ImportedTypes to find all imported classes.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

location = Corpus[:Lib]
prod_location = File.join(location, '..', 'classes')
test_location = File.join(location, 'classes')
conf_location = location
#++
require 'javaclass/dsl/mixin'

# 1) create the classpath of production classes
cp = classpath(prod_location)

# 2) remember all types defined on this classpath from JavaClass::Analyse::Dependencies 
prod_classnames = cp.types

# 3) collect all dependencies of all classes defined there
imported_classnames = cp.used_types

# 4) also collect all classes referenced from config files, defined in JavaClass::JavaNameScanner
hardcoded_classnames = scan_config_for_3rd_party_class_names(conf_location)

# 5) now we know all classes imported/used by production classes
puts '---------- used 3rd party types in production'
used_classnames = (imported_classnames + hardcoded_classnames).uniq.sort  - prod_classnames
puts used_classnames

# 6) do the same for test classes, at least org.junit.* should show up here
test_cp = classpath(test_location)
puts '---------- used 3rd party types only in tests'
test_classes = test_cp.external_types - prod_classnames - used_classnames
puts test_classes
