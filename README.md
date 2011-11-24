http://en.wikipedia.org/wiki/Legato

Google Analytics Mapper

access\_token = OAuth2 # from Google, provide instructions on getting the token!

user = Legato::User.new(access\_token)

user.accounts
user.accounts.first.profiles

user.profiles

profile = user.profiles.first

profile.user == user #=> true

class Exit
	#? extend Legato::Mapping
	#? extend Legato::Filtering
	#? extend Legato::Attribute

	extend Legato # ::Mapper/::Model

	metrics :exits, :pageviews
	dimensions :page\_path, :operating\_system, :browser

	filter :high_exits, lambda {gte(:exits, 2000)}
	filter :low_pageviews, lambda {lte(:pageviews, 200)}

	# or with dimensions
	filter :browsers, lambda {|*browsers| browsers.map {|browser| matches(:broswer, browser)}}

	filter :by_pageviews, lambda {order(:pageviews, :desc)}
	filter :one_week_ago, lambda {starts_at(Time.now - 1.week.ago)} # if you use ActiveSupport

	filter :some_predefined_ga_filter_by_name #=> optional filter id/number?
end

profile.exits #=> Query with all array methods for lazy loading

# Chaining Queries
profile.exits.high\_exits.low\_pageviews.by\_pageviews

Exit.results(profile) == profile.exits
Exit.high\_exits(profile).results == Exit.high\_exits.results(profile)

# results is our kicker, any filter/query can take a profile if you don't chain from a profile

# warn if filter references something that isn't a metric or dimension
# warn if using a method for metric on a dimension and reverse

Filtering
---------

  Google Analytics supports a significant number of filtering options.

  http://code.google.com/apis/analytics/docs/gdata/gdataReference.html#filtering

  Here is what we can do currently:
  (the operator is a method on a symbol for the appropriate metric or dimension)

  Operators on metrics:

    eql => '==',
    not_eql => '!=',
    gt => '>',
    gte => '>=',
    lt => '<',
    lte => '<='

  Operators on dimensions:

    matches => '==',
    does_not_match => '!=',
    contains => '=~',
    does_not_contain => '!~',
    substring => '=@',
    not_substring => '!@'

Accounts, WebProperties, Profiles, and Goals
--------------------------------------------

    > Legato::Management::Account.all
    > Legato::Management::WebProperty.all
    > Legato::Management::Profile.all
    > Legato::Management::Goal.all

Profiles for a UA- Number (a WebProperty)
-----------------------------------------

    > profile = Legato::Management::Profile.all.detect {|p| p.web_property_id == 'UA-XXXXXXX-X'}

Other Parameters
----------------

  * start_date: The date of the period you would like this report to start
  * end_date: The date to end, inclusive
  * limit: The maximum number of results to be returned
  * offset: The starting index
	* order: metric/dimension to order by
