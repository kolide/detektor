require_relative "constants"
require_relative "form_factors"

module Detektor
  module ClientHints
    module_function

    def parse_headers(headers)
      # this is very dumb but the ActionDispatch::Http::Headers isn't
      # a Hash, but just an Enumerable with manually added Hash-like methods
      return {} unless headers&.respond_to?(:[])
      result = {}

      HEADER_NAMES.each do |known_header|
        header_value = header_value_for(headers, known_header)

        unless header_value.nil?
          case known_header
          when HEADERS[:arch]
            result[:arch] = header_value
          when HEADERS[:bitness]
            result[:bitness] = header_value
          when HEADERS[:form_factors]
            result[:form_factors] = parse_form_factor(header_value)
          when HEADERS[:full_version_list]
            result[:full_version_list] = parse_version_list(header_value)
          when HEADERS[:is_mobile]
            result[:is_mobile] = parse_mobile(header_value)
          when HEADERS[:model]
            result[:model] = header_value
          when HEADERS[:platform]
            result[:platform] = header_value
          when HEADERS[:platform_version]
            result[:platform_version] = header_value
          when HEADERS[:user_agent]
            result[:user_agent] = parse_version_list(header_value)
          end
        end
      end

      result
    end

    def header_value_for(headers, header_str)
      str_key_value = headers[header_str]
      sym_key_value = headers[header_str.to_sym]
      return str_key_value unless str_key_value.nil?
      sym_key_value
    end

    def parse_form_factor(value)
      return [] if value.empty?

      return [value.strip] unless value.include?(",")

      value.split(",").map { |v| v.strip }
    end

    def parse_version_list(value)
      return [] if value.nil? || value.empty?

      value.scan(VERSION_LIST_REGEX)
    end

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
  end
end
