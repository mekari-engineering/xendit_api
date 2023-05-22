module XenditApi
  module Errors
    module Report
      class ResponseError < XenditApi::Errors::ResponseError; end

      class FeatureNotAvailable < ResponseError; end

      class InvalidDateRange < ResponseError; end
    end
  end
end
