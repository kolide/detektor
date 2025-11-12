require_relative "constants"
module Detektor
  module ClientHints
    class ResponseBuilder
      CRITICAL = "Critical-CH"
      ACCEPT = "Accept-CH"
      VARY = "Vary"

      def initialize(accept = [], cricital = [])
        normalize(accept, cricital)
      end

      def self.detecting(detect_option)
        return new unless ClientHints::HEADERS_FOR_PURPOSE.key?(detect_option)

        new([], ClientHints::HEADERS_FOR_PURPOSE[detect_option])
      end

      def accept_all
        @accept = @accept.union(UA_HEADERS.values)
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
        @critical = ensure_header_array(unsafe_critical)
        @accept = ensure_header_array(unsafe_accept).union(UAHeaders::LowEntropy, @critical)
      end

      def ensure_header_array(arr)
        return [] if arr.nil?
        to_ua_arr = arr.map do |v|
          case v
          when UAHeader
            v
          when Symbol
            UAHeaders.const_get(v)
          end
        end
        to_ua_arr.compact
      end
    end
  end
end
