module XenditApi
  class UrlMasker
    def self.mask(url, options = {})
      return url unless url.is_a?(String)
      return url if url.blank?
  
      url = URI.parse(url)
      UrlMasker.new(url, options).to_s
    rescue URI::Error
      url
    end
  
    def initialize(url, options = {})
      @url = url
      @mask_params = options[:mask_params] || []
      @full_hide_params = options[:full_hide_params] || []
    end
  
    def to_s
      filter(@url)
    end
  
    private
  
    def filter(url)
      query_params = URI.decode_www_form(url.query || '').to_h
      return url.to_s if query_params.blank?
  
      query_params.each do |key, value|
        if @full_hide_params.include?(key)
          query_params[key] = '*****'
        elsif @mask_params.include?(key)
          value = value.to_s
          if value.length <= 5
            query_params[key] = '*****'
            next
          end
  
          unmasked = value[0..2]
          masked = value[3..-1].gsub(/./, '*')
          query_params[key] = "#{unmasked}#{masked}"
        end
      end
      # Rebuild the URL with the masked query parameters
      masked_query = URI.encode_www_form(query_params)
      masked_url = url.dup
      masked_url.query = masked_query
      masked_url.to_s
    end
  end
end
