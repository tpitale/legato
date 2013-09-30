module Legato
  module Management
    class Segment
      extend Finder

      def self.default_path
        "/segments"
      end

      def path
        "/segments/#{id}"
      end

      attr_accessor :id, :name, :definition, :user

      def initialize(attributes, user)
        self.user = user
        self.id = attributes['id']
        self.name = attributes['name']
        self.definition = attributes['definition']
      end
    end
  end
end
