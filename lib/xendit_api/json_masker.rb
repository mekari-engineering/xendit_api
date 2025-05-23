module XenditApi
  class JsonMasker
    def self.mask(json, options = {})
      return json unless json.is_a?(String)
      return json if json.empty?

      output = JSON.parse(json)
      XenditApi::JsonMasker.new(output, options).to_masked
    rescue JSON::ParserError
      json
    end

    def initialize(data, options = {})
      @data = data
      @options = options
      @mask_params = options[:mask_params] || []
      @full_hide_params = options[:full_hide_params] || []
    end

    def to_masked
      return @data if @mask_params.empty? && @full_hide_params.empty?

      case @data
      when Array
        @data.map do |item|
          if item.is_a?(Hash)
            XenditApi::JsonMasker.new(item, @options).to_hash
          else
            item
          end
        end
      when Hash
        filter(@data)
      else
        @data
      end
    end

    def to_hash
      filter(@data)
    end

    private

    # rubocop:disable Style/CaseLikeIf
    def filter(output)
      output.each do |key, value|
        output[key] = if value.is_a?(Hash)
                        XenditApi::JsonMasker.new(value, @options).to_hash
                      elsif value.is_a?(Array)
                        value.map do |item|
                          if item.is_a?(Hash)
                            XenditApi::JsonMasker.new(item, @options).to_hash
                          else
                            item
                          end
                        end
                      else
                        mask_value(key, value)
                      end
      end
    end
    # rubocop:enable Style/CaseLikeIf

    def mask_value(key, value)
      full_hide_params_to_s = @full_hide_params.map(&:to_s)
      return '*****' if full_hide_params_to_s.include?(key.to_s)

      mask_params_to_s = @mask_params.map(&:to_s)
      return value if mask_params_to_s.include?(key.to_s) == false

      value = value.to_s
      return '*****' if value.length <= 5

      unmasked = value[0..2]
      masked = value[3..-1].gsub(/./, '*')
      "#{unmasked}#{masked}"
    end
  end
end
