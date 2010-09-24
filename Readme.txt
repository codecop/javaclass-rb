javaclass-rb
by {Peter 'Code Cop' Kofler}[http://www.code-cop.org/]

* {Homepage (Google Code)}[http://code.google.com/p/javaclass-rb/]
* {Rubyforge Project}[http://rubyforge.org/projects/javaclass]
* email peter dot kofler at code minus cop dot org

== Description

javaclass-rb (Java Class File Parser for Ruby) is a
parser and disassembler for Java class files, similar to the javap command.
It provides access to the package, protected, and public fields and methods
of the classes passed to it together with a list of all outgoing references.

== Motivation

I am still doing Java most of the time. I used to be quite enthusiatic about
it, but after 11 years I can see the advantages of being a polyglot. So I use
Ruby for all kind of stuff, just for fun. When I needed some Java class
analysis I wrote it with Ruby. As I am a puritan, I did not
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

== Documentation

The main class is JavaClass::ClassFile::JavaClassHeader which provides access to
all information of a Java class file.

* {API (RDoc)}[http://api.javaclass-rb.googlecode.com/hg/index.html]

== Support

The bug tracker is available here:

* http://code.google.com/p/javaclass-rb/issues/list

Download (tarballs and gems)

* http://code.google.com/p/javaclass-rb/downloads/list

== Dependencies

* Ruby 1.8.6
* {rubyzip}[http://rubyzip.sourceforge.net/]

== References

* {JavaWorld: The Java class file lifestyle}[http://www.javaworld.com/javaworld/jw-07-1996/jw-07-classfile.html]
* {VM Spec: The class File Format}[http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html]

== License

* {New BSD License}[http://www.opensource.org/licenses/bsd-license.php]

== Disclaimer Note

This software is provided "as is" and without any express or implied warranties,
including, without limitation, the implied warranties of merchantibility and
fitness for a particular purpose.
