module Legato
  module Management
    module Finder
      def base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def all(user, path=default_path)
        results = []

        url = base_uri + path

        while url && !url.empty?
          query = Legato::Management::Query.new(url, self)
          response = user.request(query)

          results += response.items.map { |item| new(item, user) }

          url = response.data['nextLink']
        end

        results
      end

      def get(user, path)
        query = Legato::Management::Query.new(base_uri + path, self)

        new(user.request(query).data, user)
      end
    end
  end
end
