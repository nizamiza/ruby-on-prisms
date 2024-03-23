module Helpers
  def self.strip_all(*args)
    args.flatten.map { |arg| arg.strip }
  end
end
