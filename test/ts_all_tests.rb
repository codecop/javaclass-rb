#! ruby
require 'test/unit/testsuite'
require 'test/unit' if $0 == __FILE__

# common
require File.dirname(__FILE__) + '/test_adder_tree_node'
require File.dirname(__FILE__) + '/test_string_ux'
require File.dirname(__FILE__) + '/test_string_hexdump'
require File.dirname(__FILE__) + '/test_zip_file'
require File.dirname(__FILE__) + '/test_java_name'

# Java class parser
require File.dirname(__FILE__) + '/test_class_magic'
require File.dirname(__FILE__) + '/test_class_version'
require File.dirname(__FILE__) + '/test_base'
require File.dirname(__FILE__) + '/test_constant_pool'
require File.dirname(__FILE__) + '/test_references'
require File.dirname(__FILE__) + '/test_class_access_flags'
require File.dirname(__FILE__) + '/test_class_file_attributes'
require File.dirname(__FILE__) + '/test_java_class_header'
require File.dirname(__FILE__) + '/test_java_class_header_as_java_name'

# Java class scanner
require File.dirname(__FILE__) + '/test_imported_types'

# classpath parser
require File.dirname(__FILE__) + '/test_folder_classpath'
require File.dirname(__FILE__) + '/test_jar_classpath'
require File.dirname(__FILE__) + '/test_unpacking_jar_classpath'
require File.dirname(__FILE__) + '/test_composite_classpath'
require File.dirname(__FILE__) + '/test_java_home_classpath'
require File.dirname(__FILE__) + '/test_any_classpath'
require File.dirname(__FILE__) + '/test_maven_classpath'
require File.dirname(__FILE__) + '/test_eclipse_classpath'
require File.dirname(__FILE__) + '/test_convention_classpath'
require File.dirname(__FILE__) + '/test_tracking_classpath'
require File.dirname(__FILE__) + '/test_factory'

# classpath analyser
require File.dirname(__FILE__) + '/test_transitive_dependencies'

# class list
require File.dirname(__FILE__) + '/test_jar_searcher'
require File.dirname(__FILE__) + '/test_list'
require File.dirname(__FILE__) + '/test_class_entry'
require File.dirname(__FILE__) + '/test_package_entry'

# DSL
require File.dirname(__FILE__) + '/test_java_name_factory'
require File.dirname(__FILE__) + '/test_java_name_scanner'
require File.dirname(__FILE__) + '/test_load_directive'
require File.dirname(__FILE__) + '/test_caching_classpath'

# API
require File.dirname(__FILE__) + '/test_javaclass_api'

# Graph
require File.dirname(__FILE__) + '/test_graph'
require File.dirname(__FILE__) + '/test_node'
require File.dirname(__FILE__) + '/test_edge'
require File.dirname(__FILE__) + '/test_yaml_serializer'

class TsAllTests

  def self.suite
    suite = Test::Unit::TestSuite.new("Ruby Java Class")

    # common
    suite << TestAdderTreeNode.suite
    suite << TestStringUx.suite
    suite << TestStringHexdump.suite
    suite << TestJavaClass::TestGems::TestZipFile.suite
    suite << TestJavaClass::TestPackageLogic.suite
    suite << TestJavaClass::TestSimpleNameLogic.suite
    suite << TestJavaClass::TestJavaQualifiedName.suite
    suite << TestJavaClass::TestJavaVMName.suite
    suite << TestJavaClass::TestJavaClassFileName.suite

    # Java class parser
    suite << TestJavaClass::TestClassFile::TestClassMagic.suite
    suite << TestJavaClass::TestClassFile::TestClassVersion.suite
    suite << TestJavaClass::TestClassFile::TestConstants::TestBase.suite
    suite << TestJavaClass::TestClassFile::TestConstantPool.suite
    suite << TestJavaClass::TestClassFile::TestReferences.suite
    suite << TestJavaClass::TestClassFile::TestClassAccessFlags.suite
    suite << TestJavaClass::TestClassFile::TestClassFileAttributes.suite
    suite << TestJavaClass::TestClassFile::TestJavaClassHeader.suite
    suite << TestJavaClass::TestClassFile::TestJavaClassHeaderAsJavaName.suite

    # Java class scanner
    suite << TestJavaClass::TestClassScanner::TestImportedTypes.suite

    # classpath parser
    suite << TestJavaClass::TestClasspath::TestFolderClasspath.suite
    suite << TestJavaClass::TestClasspath::TestJarClasspath.suite
    suite << TestJavaClass::TestClasspath::TestUnpackingJarClasspath.suite
    suite << TestJavaClass::TestClasspath::TestCompositeClasspath.suite
    suite << TestJavaClass::TestClasspath::TestJavaHomeClasspath.suite
    suite << TestJavaClass::TestClasspath::TestAnyClasspath.suite
    suite << TestJavaClass::TestClasspath::TestMavenClasspath.suite
    suite << TestJavaClass::TestClasspath::TestEclipseClasspath.suite
    suite << TestJavaClass::TestClasspath::TestConventionClasspath.suite
    suite << TestJavaClass::TestClasspath::TestTrackingFolderClasspath.suite
    suite << TestJavaClass::TestClasspath::TestTrackingCompositeClasspath.suite
    suite << TestJavaClass::TestClasspath::TestFactory.suite

    # classpath analyser
    suite << TestJavaClass::TestAnalyse::TestTransitiveDependencies.suite

    # class list
    suite << TestJavaClass::TestClassList::TestJarSearcher.suite
    suite << TestJavaClass::TestClassList::TestList.suite
    suite << TestJavaClass::TestClassList::TestClassEntry.suite
    suite << TestJavaClass::TestClassList::TestPackageEntry.suite

    # DSL
    suite << TestJavaClass::TestDsl::TestJavaNameFactory.suite
    suite << TestJavaClass::TestDsl::TestJavaNameScanner.suite
    suite << TestJavaClass::TestDsl::TestLoadDirective.suite
    suite << TestJavaClass::TestDsl::TestCachingClasspath.suite

    # API
    suite << TestJavaClass::TestJavaClassAPI.suite

    # Graph
    suite << TestJavaClass::TestDependencies::TestGraph.suite
    suite << TestJavaClass::TestDependencies::TestNode.suite
    suite << TestJavaClass::TestDependencies::TestEdge.suite
    suite << TestJavaClass::TestDependencies::TestYamlSerializer.suite

    return suite
  end

end
