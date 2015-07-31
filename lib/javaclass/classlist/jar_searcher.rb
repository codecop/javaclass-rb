require 'javaclass/classpath/any_classpath'
require 'javaclass/classfile/java_class_header'

module JavaClass

  # The module ClassList is for separating namespaces. It contains the logic 
  # to create a list of all classes of all JDK versions. The main logic is
  # performed in ClassList::JarSearcher, which creates the ClassList::List. 
  # It uses a 
  # Classpath::CompositeClasspath to find all classes and ClassFile::JavaClassHeader 
  # to read the class information from. The generated list contains packages 
  # and these packages contain the names of classes, their accessibility 
  # and the versions they were added (or removed) from JDK. ClassList is an 
  # "application" using the JavaClass infrastructure. For a full example see
  # {how to generate lists of JDK classes}[link:/files/lib/generated/examples/generate_class_lists_txt.html].
  # Author::          Peter Kofler
  module ClassList 

    # Search in zip or JAR files for Java class files, check for package access or inner classes and call back a list of all these.
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

      # The given _filters_ will be dropped during searching. _filters_ contain the beginning of package paths, i.e. <code>com/sun/</code>.
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

      # Return true if the _classfile_ in the given _classpath_ is public. This is expensive because the JAR file is opened and the
      # _classfile_ is extracted and read.
      def public?(classpath, classfile)
        begin
          @header = ClassFile::JavaClassHeader.new(classpath.load_binary(classfile))
        rescue JavaClass::ClassFile::ClassFormatError => ex
          ex.add_classname(classfile, classpath.to_s)
          raise ex
        end
        @header.magic.check("invalid java class #{classfile}")
        @header.access_flags.accessible?
      end

      # Compile the class list for the given _version_ of Java. This searches the _path_ for zips and JARs
      # and adds them to the given _list_ of found classes. _version_ is a number >= 0, e.g. 2 for JDK 1.2.
      # _list_ must provide a <code>add_class(entry, is_public, version)</code> method.
      def compile_list(version, path, list)
        cpe = Classpath::AnyClasspath.new(path)
        add_list_from_classpath(version, cpe, list)
        list
      end

      # Compile the class list for the given _classpath_ . This searches the _path_ for zips and JARs
      # and adds them to the given _list_ of found classes. _version_ is a number >= 0, e.g. 2 for JDK 1.2.
      # _list_ must provide a <code>add_class(entry, is_public, version)</code> method.
      def add_list_from_classpath(version, classpath, list)
        filter_classes(classpath.names).each do |entry|
          is_public = public?(classpath, entry)
          next if @skip_package_classes && !is_public
          
          inner_class_as_api = @skip_inner_classes || !@header.attributes.inner_class? || @header.attributes.accessible_inner_class?
          next if !inner_class_as_api
          
          list.add_class(entry, is_public, version) if list
          yield(entry, is_public, version) if block_given?
        end
      end
      
    end

  end
end