require 'test/unit'

# add the lib to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

TEST_DATA_PATH = File.join(File.dirname(__FILE__), 'data')

# Load the binary class data of given _name_ from the test path.
def load_class(name)
  File.open("#{TEST_DATA_PATH}/#{name}.class", 'rb') {|io| io.read } 
end

# require 'javaclass'
# require File.join(File.dirname(__FILE__), %w[.. lib javaclass])
