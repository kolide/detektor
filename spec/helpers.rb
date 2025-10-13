require "rspec/support/object_formatter"
module Helpers
  def actual_str(value)
    RSpec::Support::ObjectFormatter.format(value)
  end
end
