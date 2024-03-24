class BlockEntry
  attr_accessor :name, :type

  def initialize(name, type)
    @name = name
    @type = type
  end

  def to_s
    "#{@name} #{@type}"
  end

  def inspect
    to_s
  end
end
