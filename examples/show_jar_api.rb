# Generate a JavaClass::ClassList, which contains all class of a given
# JAR in the local Maven repository.
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
require 'javaclass/classpath/jar_classpath'
require 'javaclass/classlist/list'

# Struct to keep configuration of a Maven artefact to be searched and added.
class MavenArtefact
  attr_reader :group, :name, :version, :title

  def initialize(group, name, version, title=nil)
    @group = group
    @name = name
    @version = version
    @title = title || name
  end

  def basename
    "#{@name}-#{@version}"
  end

  def download_if_needed
    unless File.exist? to_file
      puts `#{download_command}`
    end
  end

  def to_file
    File.join(ENV['HOME'], '.m2', 'repository', @group.gsub(/\./, '/'),  @name, @version, "#{basename}.jar" )
  end

  def download_command
    "mvn org.apache.maven.plugins:maven-dependency-plugin:2.5:get -Dartifact=#{@group}:#{@name}:#{@version}"
  end
end

#--
JARS = [
  # some of the Apache Commons
  MavenArtefact.new('commons-lang', 'commons-lang', '2.6', 'Commons Lang'),
  MavenArtefact.new('org.apache.commons', 'commons-lang3', '3.1', 'Commons Lang'),
  MavenArtefact.new('commons-codec', 'commons-codec', '1.6', 'Commons Codec'),
  MavenArtefact.new('commons-beanutils', 'commons-beanutils', '1.8.3', 'Commons BeanUtils'),
  MavenArtefact.new('commons-collections', 'commons-collections', '3.2.1', 'Commons Collections'),
  MavenArtefact.new('commons-digester', 'commons-digester', '2.1', 'Commons XML Digester'),
  MavenArtefact.new('org.apache.commons', 'commons-digester3', '3.2', 'Commons XML Digester'),
  MavenArtefact.new('commons-cli', 'commons-cli', '1.2', 'Commons CLI'),
  MavenArtefact.new('org.apache.commons', 'commons-math', '2.2', 'Commons Math'),
  MavenArtefact.new('org.apache.commons', 'commons-math3', '3.0', 'Commons Math'),
  MavenArtefact.new('org.apache.commons', 'commons-jexl', '2.1.1', 'Commons JEXL'),
  MavenArtefact.new('commons-io', 'commons-io', '2.4', 'Commons IO'),
]
#++
# configuration for some artefacts
#  JARS = [ MavenArtefact.new(...), ... ]

# For all jars listed in +JARS+, load classes and write list files.
JARS.each do |artefact|

  # 1) create a new JavaClass::ClassList::List to contain the classes of this JAR
  list = JavaClass::ClassList::List.new

  # 2) create a JavaClass::ClassList::JarSearcher
  searcher = JavaClass::ClassList::JarSearcher.new
  searcher.skip_package_classes = true

  # 3) create the classpath of the artefact's JAR
  artefact.download_if_needed
  classpath = JavaClass::Classpath::JarClasspath.new(artefact.to_file())

  # 4) scan the JAR and add classes to the list
  searcher.add_list_from_classpath(artefact.version, classpath, list)

  # 5) save the list to a file
  File.open("Classes in #{artefact.title} #{artefact.version}.txt", "w") do |f|
    # print title
    f.print "*** #{artefact.title}\n"

    list.packages.each { |pkg|
      # print package name
      f.print "* #{pkg.name} - \n"
    
      # print class names
      pkg.classes.each { |c| f.print "   #{c.name}\n" }
    }
  end

  puts "processed #{artefact.name}"
end
