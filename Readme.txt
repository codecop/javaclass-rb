JavaClass
by {Peter Kofler}[http://www.code-cop.org/]

* {Homepage}[http://javaclass.rubyforge.org/]
* {Rubyforge Project}[http://rubyforge.org/projects/javaclass]
* email peter dot kofler at code-cop dot org

== Description

JavaClass (Java Class File Parser) is a
parser and disassembler for Java class files, similar to the javap command. 
It provides access to the package, protected, and public fields and methods 
of the classes passed to it together with a list of all outgoing references.   

== Motivation

I am still doing Java most of the time. I used to be quite enthusiatic about
it, but after 9 years I can see the advantages of being a polyglot. So I use
Ruby for all kind of stuff, just for fun. Recently I needed some Java class
analysis and happened to write it with Ruby. As I am a puritan, I did not
want to call javap from my script, so I started disassembling the class files,
which might be the the base for some serious static code analysis tools. (I
started adding methods to that end...) 

== Install

  sudo gem install javaclass

== Usage

  require 'javaclass'
  
  clazz = JavaClass.parse('packagename/Public.class')
  clazz.version                          # => 50.0
  clazz.constant_pool.items[1]           # => packagename/Public
  clazz.access_flags.public?             # => true
  clazz.this_class                       # => packagename/Public
  clazz.super_class                      # => java/lang/Object
  clazz.references.referenced_methods[0] # => java/lang/Object.<init>:()V

== Requirements

JavaClass does not depend on any other installed libraries or gems.

== License

Same as Ruby.

== Disclaimer Note

This software is provided "as is" and without any express or implied warranties, 
including, without limitation, the implied warranties of merchantibility and 
fitness for a particular purpose.

