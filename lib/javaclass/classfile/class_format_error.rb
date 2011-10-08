module JavaClass
  module ClassFile

    # An error in the class file format. This indicates a broken class file or not supported feature.
    # Author::   Peter Kofler
    class ClassFormatError < StandardError

      attr_reader :classname
      attr_reader :classpath

      def initialize(*args)
        super
        @classname = nil
        @classpath = nil
      end

      # Record the offending _classname_ and optional _classpath_ name.
      def add_classname(classname, classpath=nil)
        raise ArgumentError unless @classname 
        @classname = classname
        @classpath = classpath
      end

      def message
        if @classname && @classpath
          super + "\nin class #{@classname} on classpath #{@classpath}"
        elsif @classname
          super + "\nin class #{@classname}"
        else
          super
        end
      end
      
    end

  end
end