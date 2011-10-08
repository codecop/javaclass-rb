module JavaClass
  module Classpath

    # An error in the classpath. The requested classfile could not be found.
    # Author::   Peter Kofler
    class ClassNotFoundError < IOError

      attr_reader :classname
      attr_reader :classpath

      def initialize(classname, classpath=nil)
        @classname = classname
        @classpath = classpath
        super("class #{@classname} not found in classpath #{@classpath}")
      end
      
    end

  end
end
