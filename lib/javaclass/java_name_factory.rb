require 'yaml'
require 'javaclass/java_name'

module JavaClass
  # Module to mixin a mini DSL to recognize full qualified Java classnames in Ruby code.
  # Author::          Peter Kofler
  module JavaNameFactory

    # List of ISO 3166 two letter country names. Used to recognize valid domain suffix/Java package names.
    # See::            http://www.iso.org/iso/list-en1-semic-3.txt
    ISO_COUNTRIES = File.open(File.dirname(__FILE__) + '/iso_3166_countries.yaml') { |yf| YAML::load(yf) }
    # List of non  ISO 3166 U.S. domain suffix.
    US_DOMAINS = %w|com net biz org|

    # Convert the beginning of a full qualified Java classname starting with 'java' to JavaName instance.
    def java
      TemporaryJavaNamePart.new('java')
    end

    # Convert the beginning of a full qualified Java classname starting with 'javax' to JavaName instance.
    def javax
      TemporaryJavaNamePart.new('javax')
    end

    alias :__old_method_missing :method_missing

    # Convert the beginning of a full qualified Java classname to a JavaName instance.
    def method_missing(method_id, *args)
      str = method_id.id2name
      if US_DOMAINS.include?(str)
        TemporaryJavaNamePart.new(str)
      elsif ISO_COUNTRIES.include?(str)
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

      # Java reserved words are not allowed as package names.
      RESERVED_WORDS = File.open(File.dirname(__FILE__) + '/reserved_words.yaml') { |yf| YAML::load(yf) } 
      
      def initialize(history)
        @history = history
      end

      alias :__old_method_missing :method_missing

      def method_missing(method_id, *args)
        str = method_id.id2name
        if RESERVED_WORDS.include?(str)
          __old_method_missing(method_id, args)
        elsif str =~ /^[A-Z][a-zA-Z0-9_$]*$/
          JavaName.new("#{@history}.#{str}") #  a class
        elsif str == '*'
          JavaName.new("#{@history}") #  a package
        elsif str =~ /^[a-z][a-zA-Z0-9_$]*$/
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
