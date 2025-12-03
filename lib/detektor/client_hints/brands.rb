module Detektor::ClientHints
  ##
  # Contains constants relating to client hints 'brands'.
  # A brand is a company relating to the browser client.
  # For example, Chrome browser lists both Chrome and
  # Chromium, since Chromium is their engine.
  # 
  # Note that, according to spec, any brand list will include
  # at least one garbage entry (e.g. Not-A-Brand)
  module Brands
    ##
    # A Data representing a brand.
    # 
    # The +name+ should be a pretty value
    # The +regex+ should be a regex that can be used to
    # match against strings from the browser. This is used
    # to get existing constants for given header values
    Brand = Data.define :name, :regex do
      ## 
      # When a brand is not in the constants of +Brands+,
      # We create a new instance of this class, with the string
      # name duplicated into the regex value. Therefore,
      # unlisted brands will never have a Regexp for their
      # regex value, and we only want to compare names 
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

    # List of all brand constants in this module
    All = constants(false)
      .filter { |c| c != :Brand }
      .map { |c| const_get(c) }.freeze

    ##
    # If the name matches an existing Brand constant, return the constant.
    # Otherwise, create a new Brand object with the name value as the regex
    def self.brand_from(brand_name)
      All.find { |brand| brand.regex.match?(brand_name) } || Brand[brand_name, brand_name]
    end

    ## Browser-specific CH info:
    # Brave doesn't send model even when marked as critical
  end
end
