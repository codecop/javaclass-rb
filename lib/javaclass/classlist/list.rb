require 'javaclass/java_name'
require 'javaclass/classlist/package_entry'

module JavaClass
  module ClassList # :nodoc:
    
    # Classes to form a list of JDK classes to find classes which have been added in new releases.
    # The list of classes. It list contains packages.
    # Author::          Peter Kofler
    class List
      
      def initialize
        @packages = {}
      end
      
      # Add a _fileentry_ to the list. The _fileentry_ is the file name of the class in the jar file. _version_ 
      # is the version of the JDK scanned and is used if the class is new.
      def add_class(fileentry, is_public, version)
        class_name = fileentry.to_javaname.to_classname
        package_name = class_name.package
        @packages[package_name] = PackageEntry.new(package_name, version) unless @packages.has_key?(package_name)
        @packages[package_name].add_class(class_name, is_public, version)
      end
      
      # Parse a _line_ from a <code>fullClassList</code> and fill the list again. _maxversion_ is the maximum
      # max version from the list, i.e. the highest possible value, so we can continue to use it.
      def parse_line(line, maxversion)
        class_name, versions = line.scan(/^([^\s]+)\s(?:\[(.*)\]\s)?-\s*$/)[0]
        
        # no [], so we have it from always and it is public
        first_vers = 0
        last_vers = maxversion
        is_public = true
        if versions
          # extract package access and drop it
          is_public = (versions !~ /p/)
          versions = versions.gsub(/p/, '')
          
          # \d, \d-\d, only \d, -\d, oder leer
          if versions =~ /^(\d)$/
            first_vers = $1.to_i
          elsif versions =~ /^(\d)-(\d)$/
            first_vers = $1.to_i
            last_vers = $2.to_i
          elsif versions =~ /^(?:bis\s|-)(\d)$/
            last_vers = $1.to_i
          elsif versions =~ /^only (\d)$/
            first_vers = $1.to_i
            last_vers = $1.to_i
          else
            raise "can't match version number #{versions} in line #{line.chomp}" unless versions == ''
          end
        end
        
        first_vers.upto(last_vers) do |v| 
          add_class(class_name, is_public, v) 
        end
      rescue
        raise "#{$!} in line #{line.chomp}: class_name=#{class_name}, versions=#{versions}, first_vers=#{first_vers}, last_vers=#{last_vers}, is_public=#{is_public}"
      end
      
      def packages
        @packages.values.sort
      end
      
      # Return the version list of all packages.
      def version
        packages.collect { |p| p.version }.flatten.uniq.sort
      end
      
      # Return the first and last version of this list.
      def first_last_versions
        v = version
        [v.first, v.last]
      end
      
      def to_s
        packages.collect { |p| p.to_s }.join("\n")
      end
      
      # Return the number of classes in this list.
      def size
        @packages.values.inject(0) {|sum, p| sum + p.size }
      end
      
      # The access list is the raw list of all package access classes for one version. It was used to differ
      # normal classes from hidden classes and was saved in <code>doc/AccessLists/*_p.txt</code>.
      # This works only if JarSearcher was used with +skip_package_classes+ set to false (default).
      # If there are more versions loaded, then only the last version is printed. So we get consecutive lists 
      # of new package access classes with every JDK version.
      def old_access_list
        v = first_last_versions
        packages.collect { |pkg| 
          pkg.classes.find_all { |c| !c.public? && c.version == [v[1]]}.collect { |c| c.to_full_qualified_s(v[0], v[1]) }
        }.flatten.sort{|a,b| a.casecmp b }
      end
      
      # The class list is the raw list of all classes for one version without version or package access 
      # descriptors. It was used to find differences and was saved in <code>doc/ClassLists/*_classes.txt</code>.
      # This usually was done with JarSearcher set +skip_package_classes+ to false.
      # If a block is given it is invoked with ClassEntry and should return if to add the class or not. 
      def plain_class_list
        packages.collect { |pkg|
          cls = pkg.classes
          if block_given?
            cls = cls.find_all { |c| yield(c) }
          end
          cls.collect { |c| c.full_name + "\n" }
        }.flatten.sort{|a,b| a.casecmp b }
      end
      
      # Create a full class list with version numbers and different versions to compare.
      # This was the base for classlists and was saved in <code>doc/fullClassList1x.txt</code>.
      # This usually was done with JarSearcher set +skip_package_classes+ to false and
      # contained different classlists merged together.
      def full_class_list
        v = first_last_versions
        packages.collect { |pkg| 
          pkg.classes.collect { |c| c.to_full_qualified_s(v[0], v[1]) }
        }.flatten.sort{|a,b| a.casecmp b }
      end
      
    end
    
  end
end