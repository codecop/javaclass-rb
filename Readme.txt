javaclass-rb
by {Peter 'Code Cop' Kofler}[http://www.code-cop.org/]

* {Homepage (Bitbucket)}[https://bitbucket.org/pkofler/javaclass-rb]
* email peter dot kofler at code minus cop dot org

== Description

javaclass-rb (Java Class File Parser for Ruby) is a
parser and disassembler for Java class files, similar to the javap command.
It provides access to the package, protected, and public fields and methods
of the classes passed to it together with a list of all outgoing references.

== Motivation

I am still doing Java most of the time. I used to be quite enthusiastic about
it, but after 11 years I can see the advantages of being a polyglot. So I use
Ruby for all kind of stuff, just for fun. When I needed some Java class
analysis I wrote it in Ruby. As I am a puritan, I did not
want to call javap from my script, so I started disassembling the class files,
which might be the base for some serious static code analysis tools. (I
{started adding methods}[link:/files/history_txt.html] to that end and
{planned}[link:/files/planned_txt.html] for some common metrics as well.)

== Install

  sudo gem install javaclass

* {Gem Hosting}[http://rubygems.org/gems/javaclass]
* {Download of tarballs and gems}[https://bitbucket.org/pkofler/javaclass-rb/downloads]

== Documentation

Module JavaClass is the entry point for basic functions. All advanced functions are
available in Object through the JavaClass::Dsl::Mixin. The main class or the parser 
is JavaClass::ClassFile::JavaClassHeader which provides access to all information 
of a Java class file. 

* {API RDoc}[http://www.code-cop.org/api/javaclass-rb/]

I tried hard to rdoc all classes and public methods, so just {read it}[http://www.code-cop.org/api/javaclass-rb/].

== Usage

See the various examples in the examples folder of the gem. 

* {Basic Usage}[link:/files/lib/generated/examples/simple_usage_txt.html]
* Classes in modules/Jars, classpath 
  * {Number of classes in modules/JARs}[link:/files/lib/generated/examples/count_classes_in_modules_txt.html]
  * {List content of a (Maven) JAR}[link:/files/lib/generated/examples/show_jar_api_txt.html]
  * {Generate lists of JDK classes}[link:/files/lib/generated/examples/generate_class_lists_txt.html]
  * {Check names of all interfaces}[link:/files/lib/generated/examples/check_interface_names_txt.html]
* Dependencies to other classes 
  * {All imported types}[link:/files/lib/generated/examples/find_all_imported_types_txt.html]
  * {Cumulative dependencies of a class}[link:/files/lib/generated/examples/cumulative_dependencies_txt.html]
  * {Find (un)referenced JARs}[link:/files/lib/generated/examples/find_referenced_modules_txt.html] 
  * {Find unused classes}[link:/files/lib/generated/examples/find_unreferenced_classes_txt.html]
  * {Extract and chart dependencies between classes}[link:/files/lib/generated/examples/chart_class_dependencies_txt.html]
  * {Extract and chart dependency info between modules}[link:/files/lib/generated/examples/chart_module_dependencies_txt.html]
  * {Find classes that are accessed from outside the module}[link:/files/lib/generated/examples/find_incoming_dependency_graph_txt.html]
  * {Based on dependencies, sort modules into layers}[link:/files/lib/generated/examples/find_layers_of_modules_txt.html]

There is some experimental logic to recognize Java class name literals in Ruby 
which are mapped to JavaClass::JavaQualifiedName. Packages have to be suffixed 
with ".*" to be recognized. See JavaClass::Dsl::JavaNameFactory for its usage. 

== Dependencies

* Ruby 1.8.7 (also tested under 1.9.3, 2.0.0 and 2.1.6)
* {rubyzip}[https://github.com/rubyzip/rubyzip] 0.9.1 (also tested with 0.9.6.1, 0.9.9, 1.0.0 and 1.1.7)
* Originally Ruby 1.8.6 with rubyzip 0.9.1

== References

* {The Java class file lifestyle}[http://www.javaworld.com/javaworld/jw-07-1996/jw-07-classfile.html], JavaWorld 1996.
* {The class File Format}[http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html], The Java Virtual Machine Specification, Second Edition.
* {Similar Project by unageanu}[http://github.com/unageanu/javaclass], GitHub 2010. 

== License

Typically the licenses listed for the project are that of the project itself, and not of dependencies.
* {BSD License}[http://www.opensource.org/licenses/bsd-license.php], it's enclosed in {license.txt}[link:/files/license_txt.html].
