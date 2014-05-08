require 'colorize'

class String
  def colorize(params)
    self
  end
end

String.send(:remove_const, :COLORS)
String.send(:remove_const, :MODES)
String.send(:remove_const, :REGEXP_PATTERN)
String.send(:remove_const, :COLOR_OFFSET)
String.send(:remove_const, :BACKGROUND_OFFSET)
