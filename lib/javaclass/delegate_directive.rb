# Delegation directives.
# Author::          Peter Kofler
module DelegateDirective # :nodoc:
  
  # Directive to create a delegating method _method_name_ to the result of my own method _delegate_ without arguments.
  def delegate(method_name, delegate)
    self.module_eval("def #{method_name}(*obj) #{delegate}.#{method_name}(*obj) end")
  end

  # Directive to create a delegating method _method_name_ to the field _field_name_ .
  def delegate_field(method_name, field_name)
    self.module_eval("def #{method_name}(*obj) @#{field_name}.#{method_name}(*obj) end")
  end

end
