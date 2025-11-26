require "detektor/purpose"
module Detektor
  module ClientHints
    ##
    # A +Data+ describing a Sec-CH-UA- header according to the spec
    UAHeader = Data.define :spec_name, :low_entropy do
      # Explicitly return the header name so we can use
      # .join and similar array methods
      def to_str
        spec_name
      end
    end

    module UAHeaders
      # +UAHeader+ of the client's user agent.
      # Note that it has a standard format, unlike User-Agent,
      # and may not match the full info that is included in
      # User-Agent.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA]
      UserAgent = UAHeader["Sec-CH-UA", true]
      # A +UAHeader+ of the client's arch.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Arch]
      Arch = UAHeader["Sec-CH-UA-Arch", false]
      # A +UAHeader+ of the client's bitness.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Bitness]
      Bitness = UAHeader["Sec-CH-UA-Bitness", false]
      # A +UAHeader+ of the client's form factors.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Form-Factors]
      FormFactors = UAHeader["Sec-CH-UA-Form-Factors", false]
      # A +UAHeader+ of a list of all the client's versions. In general this matches the +UserAgent+
      # header, but with a full version string instead of the primary segment only.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Full-Version-List]
      FullVersionList = UAHeader["Sec-CH-UA-Full-Version-List", false]
      # A +UAHeader+ of the client's "mobileness".
      #
      # The spec implies that this could be used
      # as an 'experience preference', i.e. the client prefers a mobile experience vs not.
      # However, it does appear more accurate than the 'Desktop site' option in most mobile
      # browsers, and more importantly is not user-editable.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Mobile]
      IsMobile = UAHeader["Sec-CH-UA-Mobile", true]
      # A +UAHeader+ of the client's model.
      # This specifies the model ONLY if the +IsMobile+ header is true.
      # This fact is declared in the spec, but not in the specific section for this
      # header or on the MDN reference page.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Model],
      # {Spec section}[https://wicg.github.io/ua-client-hints/#http-ua-hints]
      Model = UAHeader["Sec-CH-UA-Model", false]
      # A +UAHeader+ of the client's platform, i.e OS
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Platform]
      Platform = UAHeader["Sec-CH-UA-Platform", true]
      # A +UAHeader+ of the client's platform version, i.e. OS version.
      #
      # See {MDN reference}[https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-CH-UA-Platform-Version]
      PlatformVersion = UAHeader["Sec-CH-UA-Platform-Version", false]

      # An array of all +UAHeader+s
      All = constants(false).map { |c| const_get(c) }.freeze

      # An array of only the low entropy +UAHeaders+s
      LowEntropy = All.filter { |h| h.low_entropy }.freeze

      # return nil when we don't find a const
      def self.const_missing?
        nil
      end
    end

    # Mapping of +Purpose+ to +UAHeaders+ necessary to detect
    HEADERS_FOR_PURPOSE = {
      Everything => UAHeaders::All,
      IsMobile => [UAHeaders::Platform, UAHeaders::IsMobile],
      ExactMobileDevice => [UAHeaders::IsMobile, UAHeaders::Model, UAHeaders::Platform, UAHeaders::PlatformVersion, UAHeaders::FormFactors],
      InstallBinaries => [UAHeaders::IsMobile, UAHeaders::Platform, UAHeaders::PlatformVersion, UAHeaders::Arch]
    }.freeze
  end
end
