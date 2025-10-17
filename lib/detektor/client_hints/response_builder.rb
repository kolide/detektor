require_relative "headers"
module Detektor
  class ClientHints
    class ResponseBuilder
      CRITICAL = "Critical-CH"
      ACCEPT = "Accept-CH"
      VARY = "Vary"

      def initialize(accept = [], cricital = [])
        normalize(accept, cricital)
      end

      def self.detecting(detect_option)
        return new unless ClientHints::HEADERS_FOR_DETECT.key?(detect_option)

        new([], ClientHints::HEADERS_FOR_DETECT[detect_option])
      end

      def accept_all
        @accept = @accept.union(ClientHints::HEADER_NAMES)
        self
      end

      def apply_headers(headers_hashlike)
        headers_hashlike[CRITICAL] = @critical.join(", ")
        headers_hashlike[ACCEPT] = @accept.join(", ")
        headers_hashlike[VARY] = @critical.join(", ")
      end

      def to_html
        # e.g. <meta http-equiv="Accept-CH" content="Width, Downlink, Sec-CH-UA" />
        html = ""
        { 
          ResponseBuilder::ACCEPT => @accept.join(", "),
          ResponseBuilder::CRITICAL => @critical.join(", "), # note that critical doesn't work like the response header
          ResponseBuilder::VARY => @critical.join(", ")
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
end
