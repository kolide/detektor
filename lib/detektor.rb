# frozen_string_literal: true

require_relative "detektor/version"
require_relative "detektor/result"
require_relative "detektor/client_hints"
require_relative "detektor/purpose"

module Detektor
  def self.detect(headers, what = nil)
    ClientHints.detect(headers, what)
  end
end
