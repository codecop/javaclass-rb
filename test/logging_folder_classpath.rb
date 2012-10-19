require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/folder_classpath'

module JavaClass
  module Classpath

    # Add a field +was_called+ to see if the load_binary was called.
    class FolderClasspath
      alias :__old_load_binary :load_binary unless method_defined?('__old_load_binary')  
      
      def load_binary(classname)
        @was_called = true
        __old_load_binary(classname)
      end
      attr_accessor :was_called
    end

  end
end
