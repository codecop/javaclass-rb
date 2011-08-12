require 'javaclass/java_language'
require 'javaclass/java_name'

module JavaClass

  # Module to mixin a mini DSL to recognize full qualified Java classnames in Ruby code.
  # Author::          Peter Kofler
  module JavaNameFactory

    # Convert the beginning of a full qualified Java classname starting with 'java' to JavaName instance.
    def java
      TemporaryJavaNamePart.new('java')
    end

    alias :__old_method_missing :method_missing

    # Convert the beginning of a full qualified Java classname to a JavaName instance.
    def method_missing(method_id, *args)
      str = method_id.id2name
      if ALLOWED_PACKAGE_PREFIX.include?(str)
        TemporaryJavaNamePart.new(str)
      else
        __old_method_missing(method_id, args)
      end
    end

    # # Overwrite the _id_ method. It's deprecated anyway.
    # def id
    #   TemporaryJavaNamePart.new('id')
    # end

    # Private temporary result to continue collecting qualified name parts.
    # Author::          Peter Kofler
    class TemporaryJavaNamePart # :nodoc:

      def initialize(history)
        @history = history
      end

      alias :__old_method_missing :method_missing

      def method_missing(method_id, *args)
        str = method_id.id2name
        if RESERVED_WORDS.include?(str)
          __old_method_missing(method_id, args)
        elsif str =~ TYPE_REGEX
          JavaName.new("#{@history}.#{str}") #  a class
        elsif str == '*'
          JavaName.new("#{@history}") #  a package
        elsif str =~ MEMBER_REGEX
          TemporaryJavaNamePart.new("#{@history}.#{str}")
        else
          __old_method_missing(method_id, args)
        end
      end

    end

  end
end

class Object # :nodoc:
  include JavaClass::JavaNameFactory
end
