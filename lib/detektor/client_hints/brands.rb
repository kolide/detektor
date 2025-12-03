module Detektor::ClientHints
  module Brands
    Brand = Data.define :name, :regex do
      def ==(other)
        return super if regex.is_a?(Regexp)
        other.class == self.class && other.name == name
      end
    end

    AndroidWebview = Brand["Android WebView", /Android WebView/i]
    Chromium = Brand["Chromium", /Chromium/i]
    GoogleChrome = Brand["Google Chrome", /Google Chrome/i]
    Brave = Brand["Brave", /Brave/i]
    SamsungInternet = Brand["Samsung Internet", /Samsung Internet/i]

    All = constants(false)
      .filter { |c| c != :Brand }
      .map { |c| const_get(c) }.freeze

    def self.brand_from(brand_name)
      All.find { |brand| brand.regex.match?(brand_name) } || Brand[brand_name, brand_name]
    end

    ## Browser-specific CH info:
    # Brave doesn't send model even when marked as critical
  end
end
