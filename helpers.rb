module Helpers
  def self.strip_all(*args)
    args.flatten.map { |arg| arg.strip }
  end

  def self.indent(str, level = 1)
    str.split("\n").map { |line| "  " * level + line }.join("\n")
  end
end
