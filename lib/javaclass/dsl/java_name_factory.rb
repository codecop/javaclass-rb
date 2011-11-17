require 'javaclass/java_language'
require 'javaclass/java_name'

module JavaClass
  module Dsl 

    # Module to mixin to recognize full qualified Java classnames in Ruby code.
    # Packages have to be suffixed with ".*" to be recognized.
    # This is a bit dangerous, as wrong method or variable names with are a valid 
    # country code are not recognized as invalid.
    # Author::          Peter Kofler
    #
    # === Usage
    #
    #  require 'javaclass/dsl/java_name_factory'
    #  include JavaNameFactory
    #  
    #  java.lang.String      # => "java.lang.String" 
    #  java.lang.*           # => "java.lang"
    # 
    module JavaNameFactory

      alias :__top_level_method_missing__ :method_missing # :nodoc:
      
      # Convert the beginning of a full qualified Java classname starting with 'java' to a JavaQualifiedName instance.
      def java
        TemporaryJavaNamePart.new('java') { __top_level_method_missing__(:java) }
      end

      # Convert the beginning of a full qualified Java classname to a JavaName instance.
      def method_missing(method_id, *args)
        str = method_id.id2name
        if JavaLanguage::ALLOWED_PACKAGE_PREFIX.include?(str)
          TemporaryJavaNamePart.new(str) { __top_level_method_missing__(method_id, args) }
        else
          __top_level_method_missing__(method_id, args)
        end
      end

      # # Overwrite the _id_ method. It's deprecated anyway.
      # def id
      #   TemporaryJavaNamePart.new('id')
      # end

      # Private temporary result to continue collecting qualified name parts.
      # Author::          Peter Kofler
      class TemporaryJavaNamePart # :nodoc:

        # Create a part with _history_ package name so far that started in _context_ instance.
        def initialize(history, &fail)
          @history = history
          @context = fail
        end

        alias :__unused_method_missing__ :method_missing

        def method_missing(method_id, *args)
          str = method_id.id2name
          if JavaLanguage::RESERVED_WORDS.include?(str)
            @context.call
          elsif str =~ /^#{JavaLanguage::TYPE_REGEX}$/
            # starts with an uppercase letter, this is a class
            JavaQualifiedName.new("#{@history}#{JavaLanguage::SEPARATOR}#{str}", &@context) 
          elsif str == '*'
            # special syntax, ending with *, this is a package
            JavaPackageName.new("#{@history}") 
          elsif str =~ JavaLanguage::PACKAGE_REGEX
            # starts with a lowercase letter, this is a package
            TemporaryJavaNamePart.new("#{@history}#{JavaLanguage::SEPARATOR}#{str}", &@context)
          else
            @context.call
          end
        end

      end

    end
  end
end
