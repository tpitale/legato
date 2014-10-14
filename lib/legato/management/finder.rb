module Legato
  module Management
    module Finder
      def base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def all(user, path=default_path)
        uri = uri_for_user(user, path)

        json = user.access_token.get(uri).body
        items = MultiJson.decode(json).fetch('items', [])
        items.map {|item| new(item, user)}
      end

      def get(user, path)
        uri = uri_for_user(user, path)
        json = user.access_token.get(uri).body

        new(MultiJson.decode(json), user)
      end

      def uri_for_user(user, path)
        if user.api_key
          # oauth + api_key
          base_uri + path + "?key=#{user.api_key}"
        else
          # oauth 2
          base_uri + path
        end
      end
    end
  end
end
