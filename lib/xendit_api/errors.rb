module XenditApi
  module Errors
    class ResponseError < StandardError; end
    class ApiValidation < ResponseError; end
    class UnknownError < ResponseError; end
    class ServerError < ResponseError; end
  end
end
