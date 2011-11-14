require 'javaclass/adder_tree'

module JavaClass
  module Analyse

    # Class dependency analysing to be mixed into LoadingClasspath.
    # Author::          Peter Kofler
    module TransitiveDependencies

      # Creates the tree of all transitive dependencies of _classname_ where every dependency is only 
      # listed once at its first occurence. It returns an AdderTree containing all found dependencies.
      # An additional block is used as _filter_ on class names to work with, e.g. the main classes.
      # Requires methods _includes?_ and _load_ in the base class.
      def transitive_dependency_tree(classname, tree=nil, &filter)
        return if block_given? && !filter.call(classname) 
        return if tree && tree.root.contain?(classname)
        
        if tree
          tree = tree.add(classname.to_classname)
        else
          tree = AdderTree.new(classname.to_classname)
        end

        if includes?(classname)
          load(classname).imported_3rd_party_types.each do |classname|
            transitive_dependency_tree(classname, tree, &filter)
          end
        end
        
        tree
      end

      # Creates the tree of all transitive dependencies of the Java _package_ where every dependency is only 
      # listed once at its first occurence. It returns an AdderTree containing all found dependencies.
      # An additional block is used as _filter_ on class names to work with, e.g. the main classes.
      # Requires a method _names_ in the base class.
      def transitive_dependencies_package(package, &filter)
        tree = AdderTree.new(package)

        names { |classname| classname.same_or_subpackage_of?(base_package) }.each do |classname| 
          transitive_dependency_tree(classname, tree, &filter)
        end
        
        tree
      end
      
    end

  end
end
