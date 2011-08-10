require 'yaml'
require 'javaclass/java_name'

module JavaClass
  # Module to mixin with logic to recognize full qualified Java classnames.
  # Author::          Peter Kofler
  module JavaNameFactory

    ISO_COUNTRIES = File.open(File.dirname(__FILE__) + '/iso_3166_countries.yaml') { |yf| YAML::load(yf) } 
    US_DOMAINS = %w|com net biz org|

    # Convert the beginning of a full qualified Java classname to JavaClass::JavaName instance.
    def java
      TemporaryJavaNamePart.new('java')
    end

    # Convert the beginning of a full qualified Java classname to JavaClass::JavaName instance.
    def javax
      TemporaryJavaNamePart.new('javax')
    end

    alias :__old_method_missing :method_missing

    # Convert the beginning of a full qualified Java classname to JavaClass::JavaName instance.
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

    class TemporaryJavaNamePart

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

class Object
  include JavaClass::JavaNameFactory
end
