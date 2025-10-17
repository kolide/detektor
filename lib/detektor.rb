# frozen_string_literal: true

require_relative "detektor/version"
require_relative "detektor/result"
require_relative "detektor/parser"
require_relative "detektor/client_hints"
require_relative "detektor/known"
require_relative "detektor/detect"

module Detektor
  def self.parse(...)
    Parser.parse(...)
  end
end
