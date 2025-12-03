require_relative "constants"
require_relative "ch_result"
require_relative "form_factor"
module Detektor
  module ClientHints
    # Both :user_agent and :full_version_list headers follow this format
    VERSION_LIST_REGEX = /"(?<name>.+?)";v="(?<version>.+?)"/

    module_function

    ##
    # Parses CH header values +selected_headers+ from given strings into their respective object shape.
    # +headers+ should be a HeaderWrapper, but can be a regular Hash for testing purposes
    def parse_headers(headers, selected_headers = UAHeaders::All)
      result = CHResult.new
      return result if headers.nil? || !headers.respond_to?(:key?)
      
      selected_headers.each do |ch_header|
        header_value = headers[ch_header.spec_name]

        unless header_value.nil?
          case ch_header
          when UAHeaders::Arch
            result.arch = clean_value(header_value)
          when UAHeaders::Bitness
            result.bitness = clean_value(header_value)
          when UAHeaders::FormFactors
            result.form_factors = parse_form_factors(header_value)
          when UAHeaders::FullVersionList
            result.add_versions(parse_version_list(header_value))
          when UAHeaders::IsMobile
            result.mobile = parse_mobile(header_value)
          when UAHeaders::Model
            result.model = clean_value(header_value)
          when UAHeaders::Platform
            result.platform = clean_value(header_value)
          when UAHeaders::PlatformVersion
            result.platform_version = clean_value(header_value)
          when UAHeaders::UserAgent
            result.add_versions(parse_version_list(header_value))
          end
        end
      end

      result
    end

    def clean_value(value)
      return value if value.nil?
      value.strip.delete('"')
    end

    def parse_list(value)
      return [] if value.empty?

      return [clean_value(value)] unless value.include?(",")

      value.split(",").map { |v| clean_value(v) }
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
