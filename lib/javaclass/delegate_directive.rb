# Delegation directives.
# Author::          Peter Kofler
module DelegateDirective # :nodoc:

  # Directive to create a simple delegating method to _delegate_ with _method_name_ .
  def delegate(method_name, delegate)
    self.module_eval("def #{method_name}(*obj) #{delegate}.#{method_name}(*obj) end")
  end

end
