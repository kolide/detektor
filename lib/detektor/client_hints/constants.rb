require "detektor/detect"
module Detektor
  module ClientHints
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
      Detektor::Detect::IsMobile => HEADERS.fetch_values(:is_mobile, :platform),
      Detect::ExactMobileDevice => HEADERS.fetch_values(:is_mobile, :model, :platform, :platform_version, :form_factors),
      Detect::InstallBinaries => HEADERS.fetch_values(:platform, :platform_version, :arch)
    }.freeze

    # Both :user_agent and :full_version_list headers follow this format
    VERSION_LIST_REGEX = /"(?<name>.+?)";v="(?<version>.+?)"/
  end
end
