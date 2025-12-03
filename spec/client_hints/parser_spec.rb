require "detektor/client_hints/parser"
require "detektor/client_hints/form_factor"
describe Detektor::ClientHints do
  describe "#parse_headers" do
    it "returns CHResult when headers nil" do
      expect(subject.parse_headers(nil)).to be_a(Detektor::ClientHints::CHResult)
    end
    it "returns CHResult when headers not hash-like" do
      expect(subject.parse_headers(22)).to be_a(Detektor::ClientHints::CHResult)
    end
  end

  describe "#parse_list" do
    it "parses empty string to empty array" do
      expect(subject.parse_list("")).to eq([])
    end

    it "parses blank string to empty array" do
      expect(subject.parse_list("  "))
    end

    it "parses string with trailing space to stripped value in array" do
      expect(subject.parse_list("test ")).to contain_exactly("test")
    end

    it "parses multiple strings with surrounding space to stripped value in array" do
      expect(subject.parse_list("    test ,  other, thing  ")).to contain_exactly("test", "other", "thing")
    end
  end

  describe "#parse_version_list" do
    it "parses empty string to empty array" do
      expect(subject.parse_version_list("")).to eq([])
    end

    it "parses blank string to empty array" do
      expect(subject.parse_version_list("  ")).to eq([])
    end

    it "returns empty array with invalid string" do
      expect(subject.parse_version_list("bah/thing; x=111")).to eq([])
    end

    it "returns correct values with one valid version item" do
      given = '"(Not(A:Brand";v="8"'
      result = subject.parse_version_list(given)
      expect(result).to have_attributes(size: 1)
      expect(result[0]).to have_attributes(size: 2)
      expect(result[0][0]).to eq("(Not(A:Brand")
      expect(result[0][1]).to eq("8")
    end

    it "returns correct values with short version strings" do
      given = '" Not A;Brand";v="99", "Chromium";v="96", "Microsoft Edge";v="96"'
      result = subject.parse_version_list(given)
      expect(result).to have_attributes(size: 3)
      expect(result).to all(have_attributes(size: 2))
      expect(result).to match_array([
        match_array([" Not A;Brand", "99"]),
        match_array(["Microsoft Edge", "96"]),
        match_array(["Chromium", "96"])
      ])
    end

    it "returns correct values with long version strings" do
      given = '" Not A;Brand";v="99.0.0.0", "Chromium";v="98.0.4750.0", "Google Chrome";v="98.0.4750.0"'
      result = subject.parse_version_list(given)
      expect(result).to have_attributes(size: 3)
      expect(result).to all(have_attributes(size: 2))
      expect(result).to match_array([
        match_array([" Not A;Brand", "99.0.0.0"]),
        match_array(["Google Chrome", "98.0.4750.0"]),
        match_array(["Chromium", "98.0.4750.0"])
      ])
    end
  end

  describe "#parse_form_factors" do
    it "returns single value for single form factor" do
      given = "Mobile"
      result = subject.parse_form_factors(given)
      expect(result).to have_attributes(size: 1)
      expect(result.first).to eq Detektor::ClientHints::FormFactors::Mobile
    end

    it "returns multiple values for multiple form factors" do
      given = "Mobile, Tablet, XR"
      result = subject.parse_form_factors(given)
      expect(result).to have_attributes(size: 3)
      expect(result).to contain_exactly(Detektor::ClientHints::FormFactors::XR, Detektor::ClientHints::FormFactors::Tablet, Detektor::ClientHints::FormFactors::Mobile)
    end
  end

  describe "#parse_mobile" do
    it "parses true-like values to true" do
      ["1", "?1", "true", true].each do |v|
        expect(subject.parse_mobile(v)).to eq(true)
      end
    end

    it "parses false-like values to false" do
      ["0", "?0", "false", false].each do |v|
        expect(subject.parse_mobile(v)).to eq(false)
      end
    end

    it "parses invalid values to nil" do
      [{}, nil, "blue", 154, [], ""].each do |v|
        expect(subject.parse_mobile(v)).to eq(nil)
      end
    end
  end
end
