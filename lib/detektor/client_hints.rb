# frozen_string_literal: true

require_relative "client_hints/constants"
require_relative "client_hints/parser"
require_relative "client_hints/response_builder"
#require_relative "result"
module Detektor
  module ClientHints
    def self.detect(headers, what = nil)
      # while we _can_ restrict which headers we process to those
      # necessary for determining `what`, we might as well process
      # all of them, because there are not that many
      parsed = parse_headers(headers)

      parsed

      # result = Result.new
      # result.ch_result = parsed

      # result.is_mobile = parsed&.is_mobile?

      # result.os = Result::Os[parsed.platform]

      # result
    end
  end
end
