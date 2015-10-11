module Legato
  module Management
    module Model

      def self.included(model)
        model.class_eval do
          attr_accessor *model::GA_ATTRIBUTES.keys
          attr_accessor :user, :attributes
        end
      end

      def initialize(attributes, user)
        self.user = user
        self.attributes = attributes

        build(attributes)
      end

      def build(attributes)
        self.class::GA_ATTRIBUTES.each do |key,string_key|
          self.send("#{key}=", attributes.delete(string_key) || attributes.delete(key))
        end
      end
    end
  end
end
