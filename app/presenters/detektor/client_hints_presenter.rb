require "detektor/client_hints"

module Detektor
  class ClientHintsPresenter
    def initialize(view, accept = [], critical = [])
      @view = view
      normalize(accept, critical)
    end

    def self.detecting(detect_option, view)
      new(view) unless ClientHints::HEADERS_FOR_DETECT.key?(detect_option)

      new(view, [], ClientHints::HEADERS_FOR_DETECT[detect_option])
    end

    def meta_tags
      # <meta http-equiv="Accept-CH" content="Width, Downlink, Sec-CH-UA" />
      html = ""
      {
        "Accept-CH": accept_headers,
        "Critical-CH": critical_headers,
        "Vary-CH": vary_headers
      }.each do |header, content|
        unless content.empty?
          html << "<meta http-equiv=\""
          html << header.to_s
          html << "\" content=\""
          html << content
          html << "\" />\n"
        end
      end
      html
    end

    def accept_all
      @accept.union(ClientHints::HEADER_NAMES)
    end

    def critical_headers
      @critical.join(", ")
    end

    def accept_headers
      @accept.join(", ")
    end

    def vary_headers
      critical_headers
    end

    private

    def normalize(unsafe_accept, unsafe_critical)
      @critical = filter_unknown(unsafe_critical || [])
      @accept = filter_unknown(unsafe_accept || []).union(ClientHints::LOW_ENTROPY_HEADERS, @critical)
    end

    def filter_unknown(arr)
      arr.filter { |v| ClientHints::HEADERS.value?(v) }
    end
  end
end
