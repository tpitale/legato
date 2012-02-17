module Legato
  module Management
    module Finder
      def base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def all(user, path=default_path)
        json = user.access_token.get(base_uri + path).body
        MultiJson.decode(json)['items'].map {|item| new(item, user)}
      end
    end
  end
end
