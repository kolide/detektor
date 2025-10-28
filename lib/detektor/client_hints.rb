# frozen_string_literal: true

require_relative "client_hints/constants"
require_relative "client_hints/parser"
module Detektor
  module ClientHints
    def self.parse(headers)
      result = parse_headers(headers)
      
    end
  end
end
