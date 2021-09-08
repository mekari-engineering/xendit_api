module XenditApi
  module Errors
    module V1
      module Ewallet
        class ResponseError < XenditApi::Errors::ResponseError; end

        class ChannelNotActivated < ResponseError; end

        class ChannelUnavailable < ResponseError; end

        class DataNotFound < ResponseError; end
      end
    end
  end
end
