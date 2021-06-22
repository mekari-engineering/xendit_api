module XenditApi
  module Errors
    module V1
      module Ewallet
        class ResponseError < StandardError; end

        class ChannelNotActivated < ResponseError; end

        class ChannelUnavailable < ResponseError; end

        class DuplicateError < ResponseError; end

        class DataNotFound < ResponseError; end
      end
    end
  end
end
