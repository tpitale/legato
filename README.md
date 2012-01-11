# Google Analytics Model/Mapper #


## Google Analytics Management ##

1. Get an OAuth2 Access Token from Google, Read OAUTH.md

        access_token = OAuth2 Access Token # from Google, see OAUTH.md

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

Profile gets a pluralized method for each class extended by Legato::Model

    Exit.results(profile) == profile.exits

We can chain off of that method, too.

    profile.exits.high_exits.low_pageviews.by_pageviews

Chaining order doesn't matter.

    Exit.high_exits(profile).results == Exit.high_exits.results(profile)

Pass the appropriate number of parameters.

For a filter defined like this:

    filter :browsers, lambda {|*browsers| browsers.map {|browser| matches(:broswer, browser)}}

We can use it like this:

    Exit.browsers("Firefox", "Safari", profile)

    # warn if filter references something that isn't a metric or dimension
    # warn if using a method for metric on a dimension and reverse

## Filtering Methods ##

Google Analytics supports a significant number of filtering options.

Here is what we can do currently:
(the operator is a method available in filters for the appropriate metric or dimension)

Operators on metrics:

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

Other Parameters
----------------

  * start_date: The date of the period you would like this report to start
  * end_date: The date to end, inclusive
  * limit: The maximum number of results to be returned
  * offset: The starting index
  * order: metric/dimension to order by
