module JavaClass
  module ClassFile

    class JavaClassHeader

      # Is this class an interface (and not an annotation)?
      def interface?
        access_flags.interface? && !access_flags.annotation?
      end

      # Is this class an abstract class (and not an interface)?
      def abstract_class?
        access_flags.abstract? && !access_flags.interface?
      end

    end

  end
end