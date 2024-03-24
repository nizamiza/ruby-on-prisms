require "./lexer/block_entry"
require "./shared/util"

class EnumEntry < BlockEntry
  def initialize(name)
    super(name, nil)
  end

  def to_s
    Util.indent(@name)
  end

  def inspect
    to_s
  end
end
