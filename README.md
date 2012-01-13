# Google Analytics Model/Mapper #

Check out the [wiki](https://github.com/tpitale/legato/wiki)

## Google Analytics Management ##

1. Get an OAuth2 Access Token from Google, Read about [OAuth2](https://github.com/tpitale/legato/wiki/OAuth2-and-Google)

        access_token = OAuth2 Access Token # from Google

2. Create a New User with the Access Token

        user = Legato::User.new(access_token)

3. List the Accounts and Profiles of the first Account

        user.accounts
        user.accounts.first.profiles

4. List all the Profiles the User has Access to

        user.profiles

5. Get a Profile

        profile = user.profiles.first

6. The Profile Carries the User

        profile.user == user #=> true


## Google Analytics Model ##

    class Exit
      extend Legato::Model

      metrics :exits, :pageviews
      dimensions :page_path, :operating_system, :browser
    end

    profile.exits #=> returns a Legato::Query
    profile.exits.each {} #=> any enumerable kicks off the request to GA

## Metrics & Dimensions ##

http://code.google.com/apis/analytics/docs/gdata/dimsmets/dimsmets.html

    metrics :exits, :pageviews
    dimensions :page_path, :operating_system, :browser

## Filtering ##

Create named filters to wrap query filters.

Here's what google has to say: http://code.google.com/apis/analytics/docs/gdata/v3/reference.html#filters

### Examples ###

Return entries with exits counts greater than or equal to 2000

    filter :high_exits, lambda {gte(:exits, 2000)}

Return entries with pageview metric less than or equal to 200

    filter :low_pageviews, lambda {lte(:pageviews, 200)}

Filters with dimensions

    filter :for_browser, lambda {|browser| matches(:broswer, browser)}

Filters with OR

    filter :browsers, lambda {|*browsers| browsers.map {|browser| matches(:broswer, browser)}}


## Using and Chaining Filters ##

Pass the profile as the first or last parameter into any filter.

    Exit.for_browser("Safari", profile)

Chain two filters.

    Exit.high_exits.low_pageviews(profile)

Profile gets a method for each class extended by Legato::Model

    Exit.results(profile) == profile.exit

We can chain off of that method, too.

    profile.exit.high_exits.low_pageviews.by_pageviews

Chaining order doesn't matter. Profile can be given to any filter.

    Exit.high_exits(profile).low_pageviews == Exit.low_pageviews(profile).high_exits

Be sure to pass the appropriate number of arguments matching the lambda for your filter.

For a filter defined like this:

    filter :browsers, lambda {|*browsers| browsers.map {|browser| matches(:broswer, browser)}}

We can use it like this, passing any number of arguments:

    Exit.browsers("Firefox", "Safari", profile)

## Google Analytics Supported Filtering Methods ##

Google Analytics supports a significant number of filtering options.

Here is what we can do currently:
(the operator is a method available in filters for the appropriate metric or dimension)

Operators on metrics (method => GA equivalent):

    eql     => '==',
    not_eql => '!=',
    gt      => '>',
    gte     => '>=',
    lt      => '<',
    lte     => '<='

Operators on dimensions:

    matches          => '==',
    does_not_match   => '!=',
    contains         => '=~',
    does_not_contain => '!~',
    substring        => '=@',
    not_substring    => '!@'

## Accounts, WebProperties, Profiles, and Goals ##

    > Legato::Management::Account.all(user)
    > Legato::Management::WebProperty.all(user)
    > Legato::Management::Profile.all(user)

## Other Parameters Can be Passed to a call to #results ##

  * :start_date - The date of the period you would like this report to start
  * :end_date - The date to end, inclusive
  * :limit - The maximum number of results to be returned
  * :offset - The starting index
  * :order - metric/dimension to order by
