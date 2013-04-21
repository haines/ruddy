class StringPointerMatcher
  def initialize(string)
    @string = string
  end

  def ==(actual)
    @string == actual.read_string
  end

  def description
    "pointer to #{@string.inspect}"
  end
end

def string_pointer(string)
  StringPointerMatcher.new(string)
end
