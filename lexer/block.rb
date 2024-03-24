require "./shared/util"

class Block
  attr_accessor :name, :type, :entries

  def initialize(name, type, is_open)
    @name = name
    @type = type
    @entries = Hash.new
  end

  def add_entry(entry)
    @entries[entry.name] = entry
  end

  def to_s
    head = Util.indent("name: #{@name}\ntype: #{@type}\nentries:")
    tail = Util.indent(@entries.map { |k, v| v.to_s}.join(
      @type == "enum" ? "\n" : "\n\n"
    ))

    "#{head}\n#{tail}"
  end

  def inspect
    to_s
  end
end
