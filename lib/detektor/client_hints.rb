# frozen_string_literal: true

require_relative "client_hints/constants"
require_relative "client_hints/parser"
require_relative "client_hints/response_builder"
module Detektor
  module ClientHints
    ##
    # Detect client hints information from given headers
    #
    # Ignores the value in +what+ and parses all values
    # because there is not much difference in size between the sets
    def self.detect(headers, what = nil)
      # while we _can_ restrict which headers we process to those
      # necessary for determining `what`, we might as well process
      # all of them, because there are not that many
      parse_headers(headers)

      # result = Result.new
      # result.ch_result = parsed

      # result.is_mobile = parsed&.is_mobile?

      # result.os = Result::Os[parsed.platform]

      # result
    end
  end
end
