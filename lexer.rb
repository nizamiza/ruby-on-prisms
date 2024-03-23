require "./block"
require "./helpers"

class Lexer
  attr_accessor :path, :enums, :models

  def initialize(path)
    @path = path
    @enums = Hash.new
    @models = Hash.new
    @current_block = nil
  end

  def lex
    File.foreach(@path) do |line|
      process_line(line)
    end
  end

  private

  def process_line(line)
    # strip whitespace and comments
    line = line.strip&.split("//")[0]

    if line.nil? || line.empty?
      return
    end

    if @current_block
      block_name, block_type = @current_block.name, @current_block.type

      sanitized_line = line.sub(/\}/, "")

      if sanitized_line.empty?
        attempt_to_close_block(line)
        return
      end

      case block_type
      when "enum"
        @enums[block_name].add_entry(EnumEntry.new(sanitized_line))
      when "model"
        match = sanitized_line.match(/(\w+)\s+(\w+)\s*(.*)?/)

        if match.nil?
          attempt_to_close_block(line)
          return
        end
          
        identifier, type, directives = Helpers.strip_all(match.captures)

        @models[block_name].add_entry(
          ModelEntry.new(identifier, type, directives)
        )
      end
      
      attempt_to_close_block(line)
      return
    end

    open_block(line)

    if @current_block.nil?
      return
    end

    case @current_block.type
    when "enum"
      @enums[@current_block.name] = @current_block
    when "model"
      @models[@current_block.name] = @current_block
    end
  end

  def open_block(line)
    # split line into tokens: <keyword> <identifier> <block-start>
    match = line.match(/(\w+)\s+(\w+)(\s*{)?/)

    if match.nil?
      @current_block = nil
      return
    end

    keyword, identifier, block_start = Helpers.strip_all(match.captures)
    block_start = block_start == "{"

    if !block_start
      @current_block = nil
      return
    end

    @current_block = Block.new(identifier, keyword, true)
  end

  def attempt_to_close_block(line)
    if @current_block.nil?
      return
    end
    
    if line.include? "}"
      @current_block = nil
    end
  end

  public

  def to_s
    enums = @enums.map { |k, v| v.to_s }.join("\n")
    models = @models.map { |k, v| v.to_s }.join("\n")

    "enums:\n#{enums}\nmodels:\n#{models}"
  end

  def inspect
    to_s
  end
end

if __FILE__ == $0
  lexer = Lexer.new(ARGV[0])
  lexer.lex

  puts lexer
end
