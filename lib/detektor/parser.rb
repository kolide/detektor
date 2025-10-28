require_relative "client_hints"

module Detektor
  module Parser
    def self.parse(headers)
      Detektor::ClientHints.parse_headers(headers)
    end
  end
end
