require_relative "result"
require_relative "known/os"
module Detektor
  module Known
    module Os
      def self.from(str)
        return nil if str.nil?

        existing = constants.find do |os|
          os.name.casecmp?(str)
        end

        return const_get(existing) unless existing.nil?

        Result::Os[str]
      end
    end
  end
end
