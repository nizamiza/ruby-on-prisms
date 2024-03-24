require "./lexer/block_entry"
require "./lexer/directive"
require "./shared/util"

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
    head = Util.indent("name: #{@name}\ntype: #{@type}")

    if @directives.empty?
      return head
    end
   
    head = Util.indent("name: #{@name}\ntype: #{@type}\ndirectives:")
    tail = Util.indent(@directives.map { |d| d.to_s }.join("\n"), 2)

    "#{head}\n#{tail}"
  end

  def inspect
    to_s
  end
end
