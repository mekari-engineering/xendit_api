module XenditPay
  module Api
    class Base
      attr_reader :client

      class << self
        def model_name
          name.sub("Api", "Model")
        end

        def model_class
          Object.const_get(model_name)
        end

        def allowed_methods
          @allowed_methods ||= []
        end

        private

        def allow_method(*methods)
          @allowed_methods = methods
        end
      end

      def initialize(client)
        @client = client
      end
    end
  end
end
