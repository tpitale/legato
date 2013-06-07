module Legato
  module Management
    module Finder
      def base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def all(user, path=default_path)
        uri = if user.api_key
          # oauth + api_key
          base_uri + path + "?key=#{user.api_key}"
        else
          # oauth 2
          base_uri + path
        end

        json = user.access_token.get(base_uri + path).body
        items = MultiJson.decode(json).fetch('items', [])
        items.map {|item| new(item, user)}
      end
    end
  end
end
