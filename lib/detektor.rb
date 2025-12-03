# frozen_string_literal: true

require_relative "detektor/version"
require_relative "detektor/result"
require_relative "detektor/client_hints"
require_relative "detektor/purpose"
require_relative "detektor/header_wrapper"

module Detektor
  def self.detect(headers, what = nil)
    ClientHints.detect(HeaderWrapper.new(headers), what)
  end
end
