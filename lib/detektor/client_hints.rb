# frozen_string_literal: true

require "detektor/known"
require "detektor/detect"
require_relative "client_hints/response_builder"
require_relative "client_hints/headers"
module Detektor
  class ClientHints
    def parse_headers(headers)
      # this is very dumb but the ActionDispatch::Http:Headers isn't
      # a Hash, but just an Enumerable with manually added Hash-like methods
      return {} unless headers&.respond_to?(:key?) && headers.respond_to?(:[])
      result = {}
      HEADER_NAMES.each do |known_header|
        if headers.key?(known_header)
          header_value = headers[known_header]
          case known_header
          when HEADERS[:is_mobile]
            result[:is_mobile] = parse_mobile(header_value)
          when HEADERS[:platform]
            os = parse_platform(header_value)

            # if we have already put the version
            # make sure to copy it
            result[:os] = if result[:os]
              os.with version: result[:os].version
            else
              os
            end
          when HEADERS[:platform_version]
            # if we haven't gotten the platform name first
            # make sure we have something there
            result[:os] ||= Known::Os::Unknown

            result[:os] = result[:os].with version: header_value
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
