class Arendelle
  VERSION = "0.1.1"

  def initialize(**opts)
    opts.each { |k, v| self[k] = v }
  end

  def []=(key, value)
    ivar = "@_#{key}"
    raise FrozenVariableError if instance_variable_get(ivar)

    instance_variable_set(ivar, value.freeze)

    if key[0] =~ /\d/
      define_singleton_method("_#{key}") do
        instance_variable_get(ivar)
      end
    else
      define_singleton_method(key) do
        instance_variable_get(ivar)
      end
    end
  end
end

class FrozenVariableError < StandardError
  def initialize(msg = "Cannot modify frozen variable")
    super(msg)
  end
end
