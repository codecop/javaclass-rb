require 'javaclass/classpath/factory'
require 'javaclass/dsl/loader'
require 'javaclass/classscanner/scanners'

# Main entry point for class file parsing. This provides all main methods as
# class methods. For an alternative usage see JavaClass::Dsl::Mixin.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.       
# License::         {BSD License}[link:/files/license_txt.html]
# TODO ? change header of all main classes to contain copyright and license as well?

module JavaClass
  extend Classpath::Factory
  extend Dsl::Loader
  extend ClassScanner::Scanners

  def self.parse(filename)
    warn 'Deprecated method JavaClass::parse will be removed in next release. Use method load_fs instead.'
    load_fs(filename)
  end
    
end
