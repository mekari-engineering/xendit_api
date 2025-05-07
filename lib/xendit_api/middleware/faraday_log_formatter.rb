require 'faraday/logging/formatter'

class FaradayLogFormatter < Faraday::Logging::Formatter
  MAX_LOG_SIZE = 10_000

  def initialize(env = {})
    @log_opts = env[:logger] || {}
    super(logger: env[:logger], options: env[:options])
  end

  def request(env)
    masked_url = UrlMasker.mask(env[:url].to_s, @log_opts)
    Rails.logger.info "#{env[:method].upcase} #{masked_url}"
    return if env[:request_body].blank?
    return if env[:request_body].size > MAX_LOG_SIZE

    message = {
      body: JsonMasker.mask(env[:request_body], @log_opts)
    }
    Rails.logger.info({ request: message }.to_json)
  end

  def response(env)
    return if env[:response_body].blank?
    return if env[:request_body].to_s.size > MAX_LOG_SIZE

    message = {
      status: env[:status],
      body: JsonMasker.mask(env[:response_body], @log_opts)
    }
    Rails.logger.info({ response: message }.to_json)
  end

  def exception(exc); end
end
