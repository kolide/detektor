# frozen_string_literal: true

require "detektor"

describe Detektor do
  describe "VERSION" do
    it "has a version number" do
      expect(Detektor::VERSION).not_to be_nil
    end
  end

  describe "#parse" do
    it "smoke test" do
      result = Detektor.parse({"Sec-CH-UA-Mobile": "?1", "Sec-CH-UA-Platform": "Android"})
      expect(result).to eq({is_mobile: true, os: Detektor::Known::Os::Android})
    end
  end
end
