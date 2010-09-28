require 'javaclass/java_name'

module JavaClass
  module ClassList # :nodoc:
    
    # An entry in the list. A ClassEntry belongs to a PackageEntry and has a list ov versions it exists in.
    # Author::          Peter Kofler
    class ClassEntry
      
      # Return the short (simple) name of this class.
      attr_reader :name
      attr_reader :full_name
      # Return the list of versions this class exists.
      attr_reader :version
      
      # Create a new entry. _parent_ must provide a +version+ field to compare against. _vers_ is the 
      # base version of this class. 
      def initialize(parent, full_name, is_public, vers)
        @parent = parent
        @full_name = full_name.to_javaname.to_classname
        @name = @full_name.simple_name
        @is_public = is_public
        @version = [vers]
      end
      
      def public?
        @is_public
      end
      
      # Update the _version_ this class also exists in.
      def update(version, is_public=@is_public)
        raise "update class #{@name} is older than its last version: latest version=#{@version.last}, new version=#{version}" if version <= @version.last
        # check for holes in versions
        if version > @version.last+1
          warn "#{@full_name} last in version #{@version.last}, not in #{@version.last+1}, but again in #{version}"        
        end
        @version << version 
        
        if !is_public && @is_public
          warn "#{@full_name} changed from public to package in version #{version}"
          @is_public = is_public
          @version = [version] # skip older versions
        elsif is_public && ! @is_public
          info "#{@full_name} changed from package to public in version #{version}"
          @is_public = is_public
          @version = [version] # skip older versions
        end
      end
      
      # Sorts by simple +name+ inside the package.
      def <=>(other)
        @name.casecmp other.name
      end
      
      def to_s
        @full_name
      end
      
      # Return a string containing the full qualified name together with first and last version
      # of this class. Ignore package versions, but obey _minversion_ and _maxversion_ .
      # Print all versions, first to last, but skip <code>first<=minversion</code> and <code>last>=maxversion</code>.
      def to_full_qualified_s(minversion, maxversion)
        format_version(@full_name, minversion, maxversion)
      end
      
      # Return a string containing the simple name and the version, if it is different from the package version.
      def to_package_shortcut_s
        vp = @parent.version
        format_version("   #{@name}", vp.first, vp.last)
      end
      
      private
      
      def format_version(start, minversion, maxversion)
        # this class has a set of versions where it exists
        # the parent has a set of versions where it exists, contains class versions
        is_newer = @version.first > minversion
        is_outdated = @version.last < maxversion
        line = start + 
          " [#{ is_newer || (!@is_public && @version.first>0) ? @version.first.to_s : ''}" +
          "#{is_outdated ? '-' + @version.last.to_s : ''}" +
          "#{!@is_public ? 'p' : '' }]" +
          " - \n"
        line.sub(/\[-0/, "[0-0").sub(/(\d)-\1/, "only \\1").sub(/ \[\]/, '')
      end
    end
    
  end
end