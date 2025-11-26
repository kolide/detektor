require "rspec/support/object_formatter"
RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 500_000
module Helpers
  def actual_str(value)
    RSpec::Support::ObjectFormatter.format(value)
  end
end
