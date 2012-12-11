javaclass-rb
by {Peter 'Code Cop' Kofler}[http://www.code-cop.org/]

* {Homepage (Google Code)}[http://code.google.com/p/javaclass-rb/]
* {Rubyforge Project (old)}[http://rubyforge.org/projects/javaclass]
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
* {Download of tarballs and gems}[http://code.google.com/p/javaclass-rb/downloads/list]

== Documentation

Module JavaClass is the entry point for basic functions. All advanced functions are
available in Object through the JavaClass::Dsl::Mixin. The main class or the parser 
is JavaClass::ClassFile::JavaClassHeader which provides access to all information 
of a Java class file. 

* {API RDoc}[http://api.javaclass-rb.googlecode.com/hg/index.html]

I tried hard to rdoc all classes and public methods, so just {read it}[http://api.javaclass-rb.googlecode.com/hg/index.html].

== Usage

See the various examples in the examples folder of the gem. 

* {Basic Usage}[link:/files/lib/generated/examples/simple_usage_txt.html]
* {Number of classes in modules/JARs}[link:/files/lib/generated/examples/count_classes_in_modules_txt.html]
* {Check names of all interfaces}[link:/files/lib/generated/examples/check_interface_names_txt.html]
* {All imported types}[link:/files/lib/generated/examples/find_all_imported_types_txt.html]
* {Cumulative dependencies of a class}[link:/files/lib/generated/examples/cumulative_dependencies_txt.html]
* {Find (un)referenced JARs}[link:/files/lib/generated/examples/find_referenced_modules_txt.html] 
* {Find unused classes}[link:/files/lib/generated/examples/find_unreferenced_classes_txt.html]
* {Extract and chart dependencies between classes}[link:/files/lib/generated/examples/chart_class_dependencies_txt.html]
* {Extract and chart dependency info between modules}[link:/files/lib/generated/examples/chart_module_dependencies_txt.html]
* {Generate lists of JDK classes}[link:/files/lib/generated/examples/generate_class_lists_txt.html]
* {List content of a (Maven) JAR}[link:/files/lib/generated/examples/show_jar_api_txt.html]

There is some experimental logic to recognize Java class name literals in Ruby 
which are mapped to JavaClass::JavaQualifiedName. Packages have to be suffixed 
with ".*" to be recognized. See JavaClass::Dsl::JavaNameFactory for its usage. 

== Support

The bug tracker is available at {Google Code}[http://code.google.com/p/javaclass-rb/issues/list]
or just drop me an email.

== How to submit patches

Read the {8 steps for fixing other people's code}[http://drnicwilliams.com/2007/06/01/8-steps-for-fixing-other-peoples-code/]
and for section 8, use the {Issue Tracker}[http://code.google.com/p/javaclass-rb/issues/list].

The trunk repository is available with

  hg clone https://javaclass-rb.googlecode.com/hg/ javaclass-rb

== Dependencies

* Ruby 1.9.2 (also tested under 1.9.3)
* {rubyzip}[http://rubyzip.sourceforge.net/] 0.9.5 (also tested with 0.9.6.1)
* Originally Ruby 1.8.6/7 with rubyzip 0.9.1

== References

* {The Java class file lifestyle}[http://www.javaworld.com/javaworld/jw-07-1996/jw-07-classfile.html], JavaWorld 1996.
* {The class File Format}[http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html], The Java Virtual Machine Specification, Second Edition.
* {Similar Project by unageanu}[http://github.com/unageanu/javaclass], GitHub 2010. 

== License

Typically the licenses listed for the project are that of the project itself, and not of dependencies.
* {BSD License}[http://www.opensource.org/licenses/bsd-license.php], it's enclosed in {license.txt}[link:/files/license_txt.html].
