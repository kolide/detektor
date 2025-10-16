require_relative "../../app/presenters/detektor/client_hints_presenter"
require "detektor/client_hints"
describe Detektor::ClientHintsPresenter do
  describe "#new with default values" do
    subject { described_class.new(nil) }
    it "gives empty string for critical" do
      expect(subject.critical_headers).to be_empty
    end
    it "gives empty string for vary" do
      expect(subject.vary_headers).to eq("")
    end

    it "gives low entropy headers for accept" do
      result = subject.accept_headers
      expect(result).not_to be_empty
      expect(result).to include(*Detektor::ClientHints::LOW_ENTROPY_HEADERS)
    end
  end

  describe "#new with only unknown values" do
    it "matches default" do
      default = described_class.new(nil)
      bad = described_class.new(nil, ["2222"], ["3333"])
      expect(bad.critical_headers).to eq(default.critical_headers)
      expect(bad.vary_headers).to eq(default.vary_headers)
      # since arr order matters when stringifying, will this fail sometimes?
      expect(bad.accept_headers).to eq(default.accept_headers)
    end
  end

  describe "#new given nils" do
    it "matches default" do
      default = described_class.new(nil)
      nils = described_class.new(nil, nil, nil)
      expect(nils.critical_headers).to eq(default.critical_headers)
      expect(nils.vary_headers).to eq(default.vary_headers)
      expect(nils.accept_headers).to eq(default.accept_headers)
    end
  end

  describe "#detecting" do
    describe "with unknown detect option" do
      it "matches default" do
        default = described_class.new(nil)
        bad = described_class.detecting(nil, nil)
        expect(bad.critical_headers).to eq(default.critical_headers)
        expect(bad.vary_headers).to eq(default.vary_headers)
        expect(bad.accept_headers).to eq(default.accept_headers)
      end
    end

    Detektor::ClientHints::HEADERS_FOR_DETECT.keys.each do |option|
      describe "with #{option}" do
        subject { described_class.detecting(option, nil) }
        it "populates vary, critical, and accept" do
          expect(subject.critical_headers).not_to be_empty
          expect(subject.vary_headers).not_to be_empty
          expect(subject.critical_headers).to eql(subject.vary_headers)
          expect(subject.accept_headers).not_to be_empty
          expect(subject.accept_headers.length).to be >= subject.critical_headers.length
        end
      end
    end
  end

  describe "#meta_tags" do
    describe "with default" do
      subject { described_class.new(nil) }
      it "is only a single line" do
        expect(subject.meta_tags.split("\n").size).to eq(1)
      end

      it "has all low entropy headers" do
        expect(subject.meta_tags).to include(*Detektor::ClientHints::LOW_ENTROPY_HEADERS)
      end
    end
  end
end
