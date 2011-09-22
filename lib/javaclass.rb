require 'javaclass/classpath/factory'
require 'javaclass/dsl/loader'
require 'javaclass/classscanner/scanners'

# Main entry point for class file parsing. This provides all main methods as
# class methods. For alternative usage see ObjectMethods.
# Author::          Peter Kofler
module JavaClass
  extend Classpath::Factory
  extend Dsl::Loader
  extend ClassScanner::Scanners

  def self.parse(filename)
    warn 'Deprecated method JavaClass::parse will be removed in next release. Use method load_fs instead.'
    load_fs(filename)
  end
    
end
