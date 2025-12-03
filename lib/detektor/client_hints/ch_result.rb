require_relative "constants"
require_relative "form_factor"
require_relative "brands"
require "pp"
module Detektor::ClientHints
  class CHResult
    attr_accessor :arch, :bitness, :form_factors, :mobile, :model, :platform, :platform_version
    attr_reader :brands

    def initialize
      @form_factors = []
      @brands = {}
    end

    def has_hints?
      # we should have gotten /something/
      # from the ch-ua header that is supposed to be passed
      # so just shortcut for now
      !@brands.empty?
    end

    def is_mobile?
      return @mobile if @mobile
      form_factors.any? { |ff| [FormFactors::Mobile, FormFactors::Tablet].include? ff }
    end

    def brand(brand)
      return nil if brand.nil?
      if brand.is_a?(Brands::Brand)
        return @brands[brand]
      end
      normalized = Brands.brand_from(brand)
      @brands[normalized]
    end

    def brand?(brand)
      return false if brand.nil?
      !brand(brand).nil?
    end

    def add_versions(brands_arr)
      return if brands_arr.nil? || brands_arr.empty?

      normalized = brands_arr.to_h.transform_keys { |k| Brands.brand_from(k) }

      @brands.merge!(normalized) do |key, new_val, old_val|
        if new_val.size > old_val.size
          new_val
        else
          old_val
        end
      end
    end

    def ==(other)
      return false if other.nil? || !other.is_a?(self.class)
      other.arch == @arch &&
        other.bitness == @bitness &&
        other.brands == @brands &&
        other.form_factors == @form_factors &&
        other.mobile == @mobile &&
        other.model == @model &&
        other.platform == @platform &&
        other.platform_version == @platform_version
    end

    def inspect
      output = "<# #{self.class.name}"
      output << " brands: "
      output << @brands.inspect
      output << " arch: #{@arch}"
      output << " bitness: #{@bitness}"
      output << " form_factors: #{@form_factors}"
      output << " mobile: #{@mobile}"
      output << " model: #{@model}"
      output << " platform: #{@platform}"
      output << " platform_version: #{@platform_version}>"
    end

    def pretty_print(pp)
      pp.group(1, "<# #{self.class.name}", ">") do
        pp.breakable
        pp.group(2, "brands={", "}") do
          @brands.each do |b, v|
            pp.text b.name
            pp.text " => "
            pp.text v
            pp.comma_breakable
          end
        end
        pp.comma_breakable
        pp.text "arch="
        pp.pp @arch
        pp.comma_breakable
        pp.text "bitness="
        pp.pp @bitness
        pp.comma_breakable
        pp.text "form_factors="
        pp.text @form_factors.map(&:name).join(",")
        pp.comma_breakable
        pp.text "mobile="
        pp.pp @mobile
        pp.breakable
        pp.text "model="
        pp.pp @model
        pp.comma_breakable
        pp.text "platform="
        pp.pp @platform
        pp.comma_breakable
        pp.text "platform_version="
        pp.pp @platform_version
      end
    end
  end
end
