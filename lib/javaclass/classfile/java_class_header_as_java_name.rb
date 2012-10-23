require 'javaclass/delegate_directive'

module JavaClass
  module ClassFile

    class JavaClassHeader
      extend DelegateDirective

      # Extend JavaClassHeader to behave like a JavaName in delegating to _this_class_ method which returns a JavaVMName.
      def to_javaname
        this_class
      end

      def to_jvmname
        this_class
      end
      
      delegate :to_classname, :this_class
      delegate :to_java_file, :this_class
      delegate :to_class_file, :this_class
      
      delegate :package, :this_class
      delegate :simple_name, :this_class
      delegate :full_name, :this_class
      delegate :same_or_subpackage_of?, :this_class
      delegate :subpackage_of?, :this_class
      delegate :split_simple_name, :this_class
      delegate :in_jdk?, :this_class

      def to_s
        to_classname
      end
      
    end

  end
end
