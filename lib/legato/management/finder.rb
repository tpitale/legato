module Legato
  module Management
    module Finder
      def base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def all(user, path=default_path)
        query = Legato::Management::Query.new(base_uri + path, self)

        user.request(query).items.map {|item| new(item, user)}
      end

      def get(user, path)
        query = Legato::Management::Query.new(base_uri + path, self)

        new(user.request(query).data, user)
      end
    end
  end
end
