# frozen_string_literal: true

require "detektor/constants"

module Detektor
  class ClientHints
    HEADERS = {
      user_agent: "Sec-CH-UA",
      arch: "Sec-CH-UA-Arch",
      bitness: "Sec-CH-UA-Bitness",
      form_factors: "Sec-CH-UA-Form-Factors",
      full_version_list: "Sec-CH-UA-Full-Version-List",
      is_mobile: "Sec-CH-UA-Mobile",
      model: "Sec-CH-UA-Model",
      platform: "Sec-CH-UA-Platform",
      platform_version: "Sec-CH-UA-Platform-Version"
    }.freeze

    HEADER_NAMES = HEADERS.values.freeze

    LOW_ENTROPY_HEADER_NAMES = [
      HEADERS[:user_agent],
      HEADERS[:is_mobile],
      HEADERS[:platform]
    ].freeze

    def parse_headers(headers)
      return {} unless headers&.is_a?(Hash)
      result = {}
      HEADER_NAMES.each do |known_header|
        if headers.key?(known_header)
          header_value = headers[known_header]
          case known_header
          when HEADERS[:is_mobile]
            result[Constants::Result::IS_MOBILE] = parse_mobile(header_value)
          end
        end
      end
      result
    end

    private

    def parse_mobile(value)
      if [true, false].include?(value)
        return value
      end
      if %w[0 ?0 false].include?(value)
        return false
      end
      if %w[1 ?1 true].include?(value)
        return true
      end
      nil
    end

    def parse_platform(value)
      nil
    end
  end
end
