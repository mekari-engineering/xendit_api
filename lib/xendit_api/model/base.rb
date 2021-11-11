module XenditApi
  module Model
    class Base
      def initialize(attributes = {})
        assign_attributes(attributes) if attributes
      end

      private

      def assign_attributes(new_attributes)
        error_message = "When assigning attributes, you must pass a hash as an argument, #{new_attributes.class} passed."
        raise ArgumentError, error_message unless new_attributes.respond_to?(:each_pair)
        return if new_attributes.empty?

        new_attributes.each do |key, value|
          assign_attribute(key, value)
        end
      end

      # Private: Set attribute with only defined resource attribute
      def assign_attribute(key, value)
        setter = :"#{key}="
        public_send(setter, value) if respond_to?(setter)
      end
    end
  end
end
