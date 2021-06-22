module XenditApi
  module Errors
    module V1
      module Ewallet
        module OVO
          class ChannelNotActivated < StandardError; end

          class ChannelUnavailable < StandardError; end

          class DuplicateError < StandardError; end

          class DataNotFound < StandardError; end
        end
      end
    end
  end
end
