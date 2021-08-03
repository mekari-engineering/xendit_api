module XenditApi
  module Errors
    class ResponseError < StandardError
      attr_reader :payload

      def initialize(message, payload = nil)
        @message = message
        @payload = payload
        super(@message)
      end
    end

    class ApiValidation < ResponseError; end
    class UnknownError < ResponseError; end
    class ServerError < ResponseError; end
  end
end
