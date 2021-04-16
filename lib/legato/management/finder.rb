module Legato
  module Management
    module Finder
      def base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def all(user, path=default_path)
        items = []

        url = base_uri + path

        loop do
          query = Legato::Management::Query.new(url, self)
          response = user.request(query)

          response.items.each { |item| items << new(item, user) }

          break if !response.data['nextLink'] || response.data['nextLink'].empty?

          url = response.data['nextLink']
        end

        items
      end

      def get(user, path)
        query = Legato::Management::Query.new(base_uri + path, self)

        new(user.request(query).data, user)
      end
    end
  end
end
