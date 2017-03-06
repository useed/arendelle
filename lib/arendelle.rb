class Arendelle
  VERSION = 0.1

  def initialize(**opts)
    opts.each { |k, v| self[k] = v }
  end

  def []=(key, value)
    ivar = "@#{key}"
    raise FrozenVariableError if instance_variable_get(ivar)

    instance_variable_set(ivar, value.freeze)

    define_singleton_method(key) do
      instance_variable_get(ivar)
    end
  end
end

class FrozenVariableError < StandardError
  def initialize(msg = "Cannot modify frozen variable")
    super(msg)
  end
end
