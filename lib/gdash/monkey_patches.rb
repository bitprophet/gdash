class GraphiteGraph
  attr_accessor :properties, :file

  # Allow method_missing *read* access to graph properties when only the method
  # name is invoked. (Defer to default implementation whenever it looks like
  # we're being used to *set* values.)
  alias_method :real_mm, :method_missing
  def method_missing(name, *args)
    if args.empty? && properties.include?(name)
      properties[name]
    else
      real_mm name, *args
    end
  end
end

class Hash
  def rmerge!(other_hash)
    merge!(other_hash) do |key, oldval, newval|
      oldval.class == self.class ? oldval.rmerge!(newval) : newval
    end
  end
end
