require 'javaclass/classpath/factory'
require 'javaclass/dsl/loader'
require 'javaclass/classscanner/scanners'

# Main namespace of JavaClass gem. The module also provides all basic methods 
# for class file parsing as class methods. For its usage see
# {Basic Usage}[link:/files/lib/generated/examples/simple_usage_txt.html]. 
# For alternative usage see JavaClass::Dsl::Mixin.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
module JavaClass
  extend Classpath::Factory
  extend Dsl::Loader
  extend ClassScanner::Scanners

  def self.parse(filename)
    warn 'Deprecated method JavaClass::parse will be removed in next release. Use method load_fs instead.'
    load_fs(filename)
  end

end
