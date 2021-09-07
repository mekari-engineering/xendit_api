module XenditApi
  module Errors
    class ResponseError < StandardError
      attr_reader :payload

      def initialize(message = nil, payload = nil)
        @message = message
        @payload = payload
        super(@message) unless @message.nil?
      end
    end

    class ApiValidation < ResponseError; end
    class UnknownError < ResponseError; end
    class ServerError < ResponseError; end
    class DuplicateError < ResponseError; end
  end
end
