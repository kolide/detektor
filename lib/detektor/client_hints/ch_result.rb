require_relative "constants"
require_relative "form_factor"
module Detektor::ClientHints
  class CHResult
    attr_accessor :arch, :bitness, :form_factors, :full_version_list, :mobile, :model, :platform, :platform_version, :user_agent

    def initialize
      @form_factors = []
      @full_version_list = []
      @user_agent = []
    end

    def is_mobile?
      mobile if mobile
      form_factors.any? { |ff| [FormFactors::Mobile, FormFactors::Tablet].include? ff }
    end

    def is_android_webview?
      return false unless is_mobile?
      puts full_version_list
    end
  end
end
