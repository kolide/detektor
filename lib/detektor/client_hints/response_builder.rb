require_relative "constants"
module Detektor
  module ClientHints
    ##
    # A class to build/apply response headers for client hints.
    # To request hints from a client reliably, the best way is
    # via response headers. In the spec, if the server specifies
    # that a client hint header is 'critical', the client should
    # retry the request with all allowed additional values specified.
    # 
    # There's some nuance here where some privacy-focused browsers 
    # still do not send all the data requested, so don't rely on
    # them 100% unless you know how the browser environment will
    # behave.
    class ResponseBuilder
      CRITICAL = "Critical-CH"
      ACCEPT = "Accept-CH"
      VARY = "Vary"

      # recommend using #detecting instead
      def initialize(accept = [], cricital = [])
        normalize(accept, cricital)
      end

      ##
      # Builds a set of response headers to request the data for the given purpose.
      # +detect_option+ should be a Detektor::Purpose
      def self.detecting(detect_option)
        return new unless ClientHints::HEADERS_FOR_PURPOSE.key?(detect_option)

        new([], ClientHints::HEADERS_FOR_PURPOSE[detect_option])
      end

      ##
      # Update the accept header value to accept all known client hint headers.
      # Returns self for chaining
      def accept_all
        @accept = @accept.union(UA_HEADERS.values)
        self
      end

      ##
      # Adds critical, accept, and vary headers to the given hash-like
      # object.
      def apply_headers(headers_hashlike)
        headers_hashlike[CRITICAL] = @critical.join(", ")
        headers_hashlike[ACCEPT] = @accept.join(", ")
        headers_hashlike[VARY] = @critical.join(", ")
      end

      ##
      # Technically, these headers can also be requested via a 'meta' tag in
      # the html page. Note that 'critical' header retry mechanism does NOT
      # work when using meta tags.
      # 
      # This method returns a raw html string containing meta tags for this builder's header values. 
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
