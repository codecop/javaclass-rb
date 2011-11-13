require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/folder_classpath'
require 'javaclass/dsl/loading_classpath'
require 'javaclass/analyse/transitive_dependencies'

module TestJavaClass
  module TestAnalyse

    class TestTransitiveDependencies < Test::Unit::TestCase

      def setup
        @cpe = JavaClass::Dsl::LoadingClasspath.new(
                  JavaClass::Classpath::FolderClasspath.new("#{TEST_DATA_PATH}/transitive_dependencies"))
        @cpe.extend(JavaClass::Analyse::TransitiveDependencies)
      end

      def test_transitive_dependency_tree_not_exist
        tree = @cpe.transitive_dependency_tree('NotExisting')
        assert_equal(1, tree.size)
      end

      def test_transitive_dependency_tree
        tree = @cpe.transitive_dependency_tree('Start')
        assert_equal(4, tree.size)
        assert_equal(['Start', ['A', ['B', 'C']]], tree.to_a)
      end

    end

  end
end
