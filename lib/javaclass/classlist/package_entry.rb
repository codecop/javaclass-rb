require 'javaclass/classlist/class_entry'

module JavaClass
  module ClassList

    # A package in the List.
    # Author::          Peter Kofler
    class PackageEntry # ZenTest FULL to find method <=>

      attr_reader :name
      # Return the list of versions this package exists. This is the sum of all versions of all classes in the package.
      attr_reader :version

      # Create a new package with name _name_ and first version _vers_ which is the version of the first class in the package.
      def initialize(name, vers=0)
        @name = name
        @version = [vers]
        @classes = {}
      end

      def add_class(class_name, is_public, version)
        @version << version unless @version.include? version
        @version = @version.sort

        unless @classes.has_key?(class_name)
          @classes[class_name] = ClassEntry.new(self, class_name, is_public, version)
        else
          @classes[class_name].update(version, is_public)
        end
      end

      # Sorting in packages is: <code>java.lang</code>, other <code>java.*</code>, <code>javax.*</code> and then others.
      def <=>(other)
        if @name =~ /^java\.lang$/ and other.name !~ /^java\.lang$/
          -1
        elsif @name !~ /^java\.lang$/ and other.name =~ /^java\.lang$/
          1
        elsif @name =~ /^java\./ and other.name !~ /^java\./
          -1
        elsif @name !~ /^java\./ and other.name =~ /^java\./
          1
        elsif @name =~ /^javax\./ and other.name !~ /^javax\./
          -1
        elsif @name !~ /^javax\./ and other.name =~ /^javax\./
          1
        else
          @name <=> other.name
        end
      end

      # Return the classes in this package.
      def classes
        @classes.values.sort
      end

      # Return the number of classes in this package.
      def size
        @classes.size
      end

      def to_s
        @name
      end

      # Special version of +to_s+ for package shortcut. A package needs _minversion_ and _maxversion_ to determine if the whole package was
      # dropped.
      def to_package_shortcut_s(minversion, maxversion)
        "#{@name}#{format_version(minversion, maxversion)} - \n" +
        classes.collect { |c| c.to_package_shortcut_s }.join
      end

      private

      def format_version(minversion, maxversion)
        is_newer = @version.first > minversion
        is_outdated = @version.last < maxversion
        line =
        " [#{ is_newer  ? @version.first.to_s : ''}" +
        "#{is_outdated ? '-' + @version.last.to_s : ''}" +
        "]"
        line.sub(/(\d)-\1/, "only \\1").sub(/ \[\]/, '')
      end

    end

  end
end