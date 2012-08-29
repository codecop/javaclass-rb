# Generate a JavaClass::ClassList, which contains all class of a given
# JAR in the local Maven repository. Use JavaClass::Classpath::MavenArtefact
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Usage

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
#++
require 'javaclass/classlist/jar_searcher'
require 'javaclass/classpath/maven_artefact'
require 'javaclass/classlist/list'

#--
JARS = [
  # some Apache Commons
#  JavaClass::Classpath::MavenArtefact.new('commons-beanutils',     'commons-beanutils', '1.8.3', 'Commons BeanUtils'),
#  JavaClass::Classpath::MavenArtefact.new('commons-cli',           'commons-cli', '1.2'),
#  JavaClass::Classpath::MavenArtefact.new('commons-codec',         'commons-codec', '1.6'),
#  JavaClass::Classpath::MavenArtefact.new('commons-collections',   'commons-collections', '3.2.1'),
#  JavaClass::Classpath::MavenArtefact.new('commons-configuration', 'commons-configuration', '1.8'),
#  JavaClass::Classpath::MavenArtefact.new('commons-digester',      'commons-digester', '2.1'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-digester3', '3.2'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-email', '1.2'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-exec', '1.1'),
#  JavaClass::Classpath::MavenArtefact.new('commons-httpclient',    'commons-httpclient', '3.0'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-id', '1.0-SNAPSHOT'),
#  JavaClass::Classpath::MavenArtefact.new('commons-io',            'commons-io', '2.4'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-jexl', '2.1.1', 'Commons JEXL'),
#  JavaClass::Classpath::MavenArtefact.new('commons-lang',          'commons-lang', '2.6'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-lang3', '3.1'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-math', '2.2'),
#  JavaClass::Classpath::MavenArtefact.new('org.apache.commons',    'commons-math3', '3.0'),
#  JavaClass::Classpath::MavenArtefact.new('commons-net',           'commons-net', '3.1'),
#  JavaClass::Classpath::MavenArtefact.new('oro',                           'oro', '2.0.8', 'Jakarta ORO'),
]
#++
# configuration for some artefacts
#  JARS = [ JavaClass::Classpath::MavenArtefact.new(...), ... ]

# For all artefacts listed in +JARS+, load classes and write list files.
JARS.each do |artefact|

  # 1) create a new JavaClass::ClassList::List to contain the classes of this JAR
  list = JavaClass::ClassList::List.new

  # 2) create a JavaClass::ClassList::JarSearcher
  searcher = JavaClass::ClassList::JarSearcher.new
  searcher.skip_package_classes = true

  # 3) create the classpath of the artefact's JAR
  artefact.download_if_needed
  classpath = artefact.classpath

  # 4) scan the JAR and add classes to the list
  searcher.add_list_from_classpath(artefact.version, classpath, list)

  # 5) save the list to a file
  File.open("Classes in #{artefact.title} #{artefact.version}.txt", "w") do |f|
    # print title
    f.print "*** #{artefact.title}\n"

    list.packages.each { |pkg|
      f.print "\n"
      # print package name
      f.print "* #{pkg.name}\n"
    
      # print class names
      pkg.classes.each { |c| f.print "   #{c.name}\n" }
    }
  end

  puts "processed #{artefact.name}"
end
