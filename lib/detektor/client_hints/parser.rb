require_relative "constants"
require_relative "ch_result"
require_relative "form_factor"
module Detektor
  module ClientHints
    module_function

    ##
    # Parses CH header values +selected_headers+ from given strings into their respective object shape.
    # +headers+ must be a hash-like object
    def parse_headers(headers, selected_headers = UAHeaders::All)
      # this is very dumb but the ActionDispatch::Http::Headers isn't
      # a Hash, but just an Enumerable with manually added Hash-like methods
      return nil unless headers&.respond_to?(:[])
      result = CHResult.new

      selected_headers.each do |ch_header|
        header_value = header_value_for(headers, ch_header.spec_name)

        unless header_value.nil?
          case ch_header
          when UAHeaders::Arch
            result.arch = header_value
          when UAHeaders::Bitness
            result.bitness = header_value
          when UAHeaders::FormFactors
            result.form_factors = parse_form_factors(header_value)
          when UAHeaders::FullVersionList
            result.full_version_list = parse_version_list(header_value)
          when UAHeaders::IsMobile
            result.mobile = parse_mobile(header_value)
          when UAHeaders::Model
            result.model = header_value
          when UAHeaders::Platform
            result.platform = header_value
          when UAHeaders::PlatformVersion
            result.platform_version = header_value
          when UAHeaders::UserAgent
            result.user_agent = parse_version_list(header_value)
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

    def parse_list(value)
      return [] if value.empty?

      return [value.strip] unless value.include?(",")

      value.split(",").map { |v| v.strip }
    end

    def parse_version_list(value)
      return [] if value.nil? || value.empty?

      value.scan(VERSION_LIST_REGEX)
    end

    def parse_form_factors(value)
      parse_list(value).map { |s| FormFactor[s] }
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
