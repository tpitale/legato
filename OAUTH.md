# Authorizing requests with OAuth 2.0 #

## Creating the client ##

* Go to the [API Console](https://code.google.com/apis/console#access)
* Create a new Project
* Click API Access in the left column
* Click Create an OAuth 2.0 client ID
* Enter a product name, and add an optional logo
* Click next
* Select Installed Application
* Click create client id
* Hang onto the client id and secret

client = OAuth2::Client.new('779170787975.apps.googleusercontent.com', 'mbCISoZiSwyVQIDEbLj4EeEc', :authorize_url => 'https://accounts.google.com/o/oauth2/auth', :token_url => 'https://accounts.google.com/o/oauth2/token')

client.auth_code.authorize_url(:scope => 'https://www.googleapis.com/auth/analytics.readonly', :redirect_uri => 'http://localhost')

access_token = client.auth_code.get_token('4/Wdfs_g6f8LU3uIjuPHMd3VgSsiDa', :redirect_uri => 'http://localhost')

json = access_token.get('https://www.googleapis.com/analytics/v3/management/accounts').body
JSON.parse(json)
