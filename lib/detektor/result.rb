module Detektor
  module Result
    Os = Data.define :name, :version do
      def initialize name:, version: nil
        super
      end
    end
  end
end
