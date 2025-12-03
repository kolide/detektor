require "detektor/client_hints/ch_result"
require "pp"
describe Detektor::ClientHints::CHResult do

  context "nil tests" do
    it "returns false if brand? nil" do
      expect(subject.brand?(nil)).to be false
    end
    it "returns nil if brand nil" do
      expect(subject.brand(nil)).to be nil
    end

    it "returns nil if brand empty string" do
      expect(subject.brand("")).to be nil
    end

    it "pretty print" do
      result = PP.pp(subject, "")
      expect(result).to_not be nil
    end
    
    it "inspect" do
      expect(subject.inspect).to_not be nil
    end
  end

  context "equals" do
    it "== nil is false" do
      expect(subject == nil).to be false
    end
    it "== string is false" do
      expect(subject == "blah").to be false
    end
  end

  context "with a macOS-like result" do
    subject {
      described_class.new.tap do |sub|
        sub.mobile = false
        sub.arch = "arm64"
        sub.bitness = "64"
        sub.model = ""
        sub.form_factors = [Detektor::ClientHints::FormFactor["Desktop"]]
        sub.platform = "macOS"
        sub.platform_version = "15.7.1"
        # user_agent
        sub.add_versions([
          ["Chromium", "142"],
          ["Google Chrome", "142"],
          ["Not_A Brand", "99"]
        ])
        # full_version_list
        sub.add_versions([
          ["Chromium", "142.0.7444.135"],
          ["Google Chrome", "142.0.7444.135"],
          ["Not_A Brand", "99.0.0.0"]
        ])
      end
    }

    it "is not mobile" do
      expect(subject.is_mobile?).to be false
    end

    it "is not an android webview" do
      expect(subject.brand?(Detektor::ClientHints::Brands::AndroidWebview)).to be false
    end

    it "has brand chrome from string" do
      expect(subject.brand?("Google Chrome")).to be true
    end

    it "returns brand chrome version from string" do
      expect(subject.brand("Google Chrome")).to start_with("142")
    end

    it "pretty print" do
      result = PP.pp(subject, "")
      expect(result).to_not be nil
    end
  end
end
