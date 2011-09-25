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
started adding methods to that end...)

== Install

  sudo gem install javaclass

* {Gem Hosting}[http://rubygems.org/gems/javaclass]
* {Download of tarballs and gems}[http://code.google.com/p/javaclass-rb/downloads/list]

== Usage

See the various examples in the examples folder of the gem.

== Documentation

Module +JavaClass+ is the entry point for most functions in the gem.
The main class is JavaClass::ClassFile::JavaClassHeader which provides access
to all information of a Java class file. There are also some examples in the
examples folder of the gem.

* {API RDoc}[http://api.javaclass-rb.googlecode.com/hg/index.html]

== Support

The bug tracker is available at http://code.google.com/p/javaclass-rb/issues/list
or just drop me an email.

== How to submit patches

Read the {8 steps for fixing other people's code}[http://drnicwilliams.com/2007/06/01/8-steps-for-fixing-other-peoples-code/]
and for section 8, use the {Issue Tracker here}[http://code.google.com/p/javaclass-rb/issues/list].

The trunk repository is available with

  hg clone https://javaclass-rb.googlecode.com/hg/ javaclass-rb

== Dependencies

* Ruby 1.8.6 (runs with 1.8.7 and 1.9.1, too)
* {rubyzip}[http://rubyzip.sourceforge.net/] 0.9.1

== References

* {JavaWorld: The Java class file lifestyle}[http://www.javaworld.com/javaworld/jw-07-1996/jw-07-classfile.html]
* {VM Spec: The class File Format}[http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html]
* {Similar Project by unageanu}[http://github.com/unageanu/javaclass]

== License

* {New BSD License}[http://www.opensource.org/licenses/bsd-license.php]

== Disclaimer Note

This software is provided "as is" and without any express or implied warranties,
including, without limitation, the implied warranties of merchantability and
fitness for a particular purpose.
