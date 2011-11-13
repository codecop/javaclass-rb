require 'javaclass/adder_tree'

module JavaClass
  module Analyse

    # Class dependency analysing to be mixed into LoadingClasspath.
    # Author::          Peter Kofler
    module TransitiveDependencies

      # Creates the tree of all transitive dependencies where every dependency is only listed once 
      # (it's first occurence). It returns an AdderTree containing all found dependencies.
      # Requires methods _includes?_ and _load_ in the base class.
      def transitive_dependency_tree(classname, tree=nil)
        return if tree && tree.root.contain?(classname)
        
        if tree
          tree = tree.add(classname)
        else
          tree = AdderTree.new(classname)
        end

        if includes?(classname)
          load(classname).imported_3rd_party_types.each do |classname|
            transitive_dependency_tree(classname, tree)
          end
        end
        
        tree
      end

      # Creates the tree of all transitive dependencies of a Java package where every dependency is only 
      # listed once (it's first occurence). It returns an AdderTree containing all found dependencies.
      # Requires a method _names_ in the base class.
      def transitive_dependencies_package(base_package)
        tree = AdderTree.new(base_package)

        names { |classname| classname.same_or_subpackage_of?(base_package) }.each do 
          transitive_dependency_tree(classname, tree)
        end
        
        tree
      end
      
    end

  end
end
