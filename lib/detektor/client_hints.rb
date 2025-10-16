# frozen_string_literal: true

require "detektor/known"
require "detektor/detect"
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

    LOW_ENTROPY_HEADERS = HEADERS.fetch_values(:user_agent, :is_mobile, :platform).freeze

    HEADERS_FOR_DETECT = {
      Detect::IsMobile => HEADERS.fetch_values(:is_mobile, :platform),
      Detect::ExactMobileDevice => HEADERS.fetch_values(:is_mobile, :model, :platform, :platform_version, :form_factors),
      Detect::InstallBinaries => HEADERS.fetch_values(:platform, :platform_version, :arch)
    }.freeze

    def parse_headers(headers)
      return {} unless headers&.is_a?(Hash)
      result = {}
      HEADER_NAMES.each do |known_header|
        if headers.key?(known_header)
          header_value = headers[known_header]
          case known_header
          when HEADERS[:is_mobile]
            result[:is_mobile] = parse_mobile(header_value)
          when HEADERS[:platform]
            os = parse_platform(header_value)

            if headers.key?(HEADERS[:platform_version])
              os = os.with version: headers[HEADERS[:platform_version]]
            end

            result[:os] = os

          when HEADERS[:model]
            result[:model] = parse_model(header_value)
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
      Known::Os.from(value)
    end

    def parse_model(value)
      value
    end
  end
end
