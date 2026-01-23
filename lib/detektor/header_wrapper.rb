module Detektor
  ##
  # Wraps header objects to reduce duplicated code dealing
  # with differences in formatting and structure.
  class HeaderWrapper
    def initialize(headers)
      @wrapped = headers
      set_strategies(headers)
    end

    def key?(key)
      @key_strategy.call(key).any { |k| @wrapped.key?(k) }
    end

    def [](key)
      @key_strategy.call(key).lazy
        .map { |k| @wrapped[k] }
        .find { |v| !v.nil? }
    end

    def set_strategies(headers)
      @key_strategy = if defined?(Rails) && headers.instance_of?(::ActionDispatch::Http::Headers)
        method(:key_string)
      else
        method(:key_unknown)
      end
    end

    private

    def key_string(key)
      [key.to_s]
    end

    def key_unknown(key)
      [key.to_s, key.to_sym, key.to_s.downcase]
    end
  end
end
