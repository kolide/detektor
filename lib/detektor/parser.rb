require_relative "client_hints"

module Detektor
  module Parser
    def self.parse(headers)
      Detektor::ClientHints.new.parse_headers(headers)
    end
  end
end
