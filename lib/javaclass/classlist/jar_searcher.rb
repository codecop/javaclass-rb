require 'javaclass/classpath/composite_classpath'
require 'javaclass/classfile/java_class_header'

module JavaClass
  module ClassList # :nodoc:
    
    # Search in zip or jar files for Java class files, check for package access or inner classes and
    # call back a list of all these.
    # Author::          Peter Kofler
    class JarSearcher
      
      attr_accessor :skip_inner_classes
      attr_accessor :skip_package_classes
      
      # Create a new searcher.
      def initialize
        @skip_inner_classes = true
        @skip_package_classes = false
        @package_filters = []
      end
      
      # The given _filters_ will be dropped during searching.
      # _filters_ contain the beginning of package paths, i.e. <code>com/sun/</code>.
      def filters=(filters)
        @package_filters = filters.collect{ |f| /^#{f}/ }
      end
      
      # Return the list of classnames of this list of _classes_ .
      # Skips inner classes if +skip_inner_classes+ is true.
      # Skips classes that are in the filtered packages.
      def filter_classes(classes)
        classes.find_all do |name|
          !(@skip_inner_classes && name =~ /\$/) && (@package_filters.find { |filter| name =~ filter } == nil)
        end
      end
      
      # Return true if the _classfile_ in the given _classpath_ is public. This is expensive because
      # the jarfile is opened and the _classfile_ is extracted and read.
      def public?(classpath, classfile)
        begin
          header = ClassFile::JavaClassHeader.new(classpath.load_binary(classfile))
        rescue
          puts "error #{$1} for class #{classfile} on #{classpath.to_s}"
          raise
        end
        raise "invalid java class #{classfile}" unless header.magic.valid?
        header.access_flags.accessible?
      end
      
      # Compile the class list for the given _version_ of Java. This searches the _path_ for zips and jars
      # and adds them to the given _list_ of found classes. _version_ is a number >= 0, e.g. 2 for JDK 1.2.
      # _list_ must provide a <code>add_class(entry, is_public, version)</code> method.
      def compile_list(version, path, list)
        cpe = JavaClass::Classpath::CompositeClasspath.new
        cpe.find_jars(path)
        filter_classes(cpe.names).each do |entry|
          is_public = public?(cpe, entry)
          next if @skip_package_classes && !is_public
          list.add_class(entry, is_public, version) if list
          yield(entry, is_public, version) if block_given?
        end
        
        list
      end
      
    end
    
  end
end