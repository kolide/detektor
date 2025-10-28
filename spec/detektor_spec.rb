# frozen_string_literal: true

require "detektor"

describe Detektor do
  describe "VERSION" do
    it "has a version number" do
      expect(Detektor::VERSION).not_to be_nil
    end
  end
end
