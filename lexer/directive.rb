class Directive
  attr_accessor :name, :args

  def initialize(str)
    match = str.strip.match(/(\w+)\((.*)\)/)
    args = nil

    if match.nil?
      @name = str
    else
      @name, args = match.captures
    end

    @args = Hash.new

    if args
      args.split(",").each do |arg|
        key, value = arg.split(":").map { |part| part.strip }
        @args[key] = value
      end
    end
  end

  def to_s
    "#{@name}: #{@args}"
  end

  def inspect
    to_s
  end
end
