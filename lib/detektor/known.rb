require_relative "result"
require_relative "known/os"
module Detektor
  module Known
    module Os
      def self.from(str)
        existing = constants.find do |os|
          os.name.casecmp?(str)
        end

        const_get(existing) || Result::Os[str]
      end
    end
  end
end
