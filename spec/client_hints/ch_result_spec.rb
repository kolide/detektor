require "detektor/client_hints/ch_result"
describe Detektor::ClientHints::CHResult do

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
      expect(subject.is_android_webview?).to be false
    end
  end
end
