# Java Class File Parser for Ruby #

## Description ##
javaclass-rb (Java Class File Parser for Ruby) is a
parser and disassembler for Java class files, similar to the javap command.
It provides access to the package, protected, and public fields and methods
of the classes passed to it together with a list of all outgoing references.

## Motivation ##
I am still doing Java most of the time. I used to be quite enthusiastic about
it, but after 11 years I can see the advantages of being a polyglot. So I use
Ruby for all kind of stuff, just for fun. When I needed some Java class
analysis I wrote it with Ruby. As I am a puritan, I did not
want to call `javap` from my script, so I started disassembling the class files,
which might be the base for some serious static code analysis tools. (I
started adding methods to that end...)

## Goals ##
 * searching and accessing class files
 * parsing meta data of class files
 * displaying this meta data
 * analysing the structure of class files (down to field/method level)
 * calculating numbers based on this structure
 * calculating higher metrics
 * "static code analysis"

## Non Goals ##
 * parsing the actual byte code
 * verifying byte code
 * generating byte code
 * generating class files
 * executing byte code

## Documentation ##
Module `JavaClass` is the entry point for basic functions. All advanced functions are
available in Object through the `JavaClass::Dsl::Mixin`. The main class or the parser 
is `JavaClass::ClassFile::JavaClassHeader` which provides access to all information 
of a Java class file. 
Read the [API RDoc](http://www.code-cop.org/api/javaclass-rb/).

### License ###
[New BSD License](http://opensource.org/licenses/bsd-license.php), see `license.txt` in repository.
