require 'javaclass/delegate_directive'

module JavaClass
  module ClassFile

    # Extend JavaClassHeader to behave like a JavaName in delegating to _this_class_ method.
    # Author::          Peter Kofler
    class JavaClassHeader
      extend DelegateDirective

      def to_javaname
        self
      end

      delegate :package, :this_class
      delegate :simple_name, :this_class
      delegate :full_name, :this_class
      delegate :same_or_subpackage_of?, :this_class
      delegate :subpackage_of?, :this_class
      delegate :to_classname, :this_class
      delegate :to_jvmname, :this_class
      delegate :to_java_file, :this_class
      delegate :to_class_file, :this_class
      delegate :split_simple_name, :this_class
      delegate :in_jdk?, :this_class

    end

  end
end
