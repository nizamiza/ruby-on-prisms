require "./helpers"

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
    head = Helpers.indent("name: #{@name}\ntype: #{@type}\nentries:")
    tail = Helpers.indent(@entries.map { |k, v| v.to_s}.join(
      @type == "enum" ? "\n" : "\n\n"
    ))

    "#{head}\n#{tail}"
  end

  def inspect
    to_s
  end
end

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

class EnumEntry < BlockEntry
  def initialize(name)
    super(name, nil)
  end

  def to_s
    Helpers.indent(@name)
  end

  def inspect
    to_s
  end
end

class ModelEntry < BlockEntry
  attr_accessor :directives

  def initialize(name, type, directives)
    super(name, type)

    if directives.empty?
      @directives = Array.new
      return
    end

    # @id @default("uuid") @unique ...
    @directives = directives
      .split("@")
      .map { |directive| directive.strip }
      .reject { |directive| directive.empty? }
      .map { |directive| Directive.new(directive) }
  end

  def to_s
    head = Helpers.indent("name: #{@name}\ntype: #{@type}")

    if @directives.empty?
      return head
    end
   
    head = Helpers.indent("name: #{@name}\ntype: #{@type}\ndirectives:")
    tail = Helpers.indent(@directives.map { |d| d.to_s }.join("\n"), 2)

    "#{head}\n#{tail}"
  end

  def inspect
    to_s
  end
end

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
