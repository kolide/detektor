require "detektor/client_hints"
require "detektor/client_hints/response_builder"
HEADER = {
  critical: Detektor::ClientHints::ResponseBuilder::CRITICAL,
  accept: Detektor::ClientHints::ResponseBuilder::ACCEPT,
  vary: Detektor::ClientHints::ResponseBuilder::VARY
}

describe Detektor::ClientHints::ResponseBuilder do
  def header_result(builder)
    hash = {}
    builder.apply_headers(hash)
    hash
  end
  describe "#new with default values" do
    subject { header_result(described_class.new) }
    it "gives empty string for critical" do
      expect(subject[HEADER[:critical]]).to be_empty
    end
    it "gives empty string for vary" do
      expect(subject[HEADER[:vary]]).to eq("")
    end

    it "gives low entropy headers for accept" do
      result = subject[HEADER[:accept]]
      expect(result).not_to be_empty
      expect(result).to include(*Detektor::ClientHints::UAHeaders::LowEntropy)
    end
  end

  describe "#new with only unknown values" do
    it "matches default" do
      default = header_result(described_class.new)
      bad = header_result(described_class.new(["2222"], ["3333"]))

      expect(bad).to eq(default)
    end
  end

  describe "#new given nils" do
    it "matches default" do
      default = header_result(described_class.new(nil))
      nils = header_result(described_class.new(nil, nil))
      expect(nils).to eq(default)
    end
  end

  describe "#detecting" do
    describe "with unknown detect option" do
      it "matches default" do
        default = header_result(described_class.new)
        bad = header_result(described_class.detecting(nil))
        expect(bad).to eq(default)
      end
    end

    Detektor::ClientHints::HEADERS_FOR_PURPOSE.keys.each do |option|
      describe "with #{option}" do
        subject { described_class.detecting(option) }
        it "populates vary, critical, and accept" do
          headers = header_result(subject)
          expect(headers[HEADER[:critical]]).not_to be_empty
          expect(headers[HEADER[:vary]]).not_to be_empty

          expect(headers[HEADER[:critical]]).to eql(headers[HEADER[:vary]])

          expect(headers[HEADER[:accept]]).not_to be_empty
          expect(headers[HEADER[:accept]].length).to be >= headers[HEADER[:critical]].length
        end
      end
    end
  end

  describe "#to_html" do
    describe "with default" do
      subject { described_class.new(nil) }
      it "is only a single line" do
        expect(subject.to_html.split("\n").size).to eq(1)
      end

      it "has all low entropy headers" do
        expect(subject.to_html).to include(*Detektor::ClientHints::UAHeaders::LowEntropy)
      end
    end
  end
end
