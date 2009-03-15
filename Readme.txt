JavaClass
   by Peter Kofler

* {Homepage}[http://javaclass.rubyforge.org/]
* {Rubyforge Project}[http://rubyforge.org/projects/javaclass]
* email bruno41 at rubyforge dot org 

== Description

JavaClass (Java Class File Parser) is a
parser and disassembler for Java class files, similar to the javap command. 
It provides access to the package, protected, and public fields and methods 
of the classes passed to it together with a list of all outgoing references.   

== Install

  sudo gem install javaclass

== Usage

  require 'javaclass'
  
  clazz = JavaClass.parse('folder/PublicClass.class')
  clazz.version                                # => 50.0
  clazz.accessible?                            # => true 

== Requirements

JavaClass does not depend on any other installed libraries or gems.

== License

Same as Ruby.
