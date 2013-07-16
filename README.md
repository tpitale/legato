# Legato: Google Analytics Model/Mapper #
[![Build Status](https://travis-ci.org/tpitale/legato.png)](https://travis-ci.org/tpitale/legato)

## [Check out the Wiki!](https://github.com/tpitale/legato/wiki) ##

If you've come here from Garb, welcome! There are a few changes from Garb, so you'll want to check out:

* [Model Data](https://github.com/tpitale/legato/wiki/Model-Data)
* [Query Parameters](https://github.com/tpitale/legato/wiki/Query-Parameters)
* And the biggest difference: [Filtering](https://github.com/tpitale/legato/wiki/Filtering)
 
If you're not able to upgrade quite yet, Garb has been maintained https://github.com/Sija/garb

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

    filter :high_exits, &lambda {gte(:exits, 2000)}

Return entries with pageview metric less than or equal to 200

    filter :low_pageviews, &lambda {lte(:pageviews, 200)}

Filters with dimensions

    filter :for_browser, &lambda {|browser| matches(:browser, browser)}

Filters with OR

    filter :browsers, &lambda {|*browsers| browsers.map {|browser| matches(:browser, browser)}}


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

    filter :browsers, &lambda {|*browsers| browsers.map {|browser| matches(:browser, browser)}}

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

## Dynamic Segment

Your query can have a dynamic segment, which works with filter expressions. It
works like an [advanced
segment](https://support.google.com/analytics/answer/1033017?hl=en), except you
don't have to create it beforehand, you can just specify it at query time.

Some of the numbers you'll get will be different from using a filter, since
[the subset of visits matched happens before dimensions and metrics are
calculated](http://ga-dev-tools.appspot.com/explorer/) (hover on the `segment`
parameter to see).

Some metrics and dimensions are not allowed for segments, see the [API
documentation](https://developers.google.com/analytics/devguides/reporting/core/v3/reference#segment)
for more details.

### Defining, using and chaining filters

Return entries with exits counts greater than or equal to 2000

    segment :high_exits do
      gte(:exits, 2000)
    end

Return entries with pageview metric less than or equal to 200

    segment :low_pageviews do
      lte(:pageviews, 200)
    end

You can chain them

    Exit.high_exits.low_pageviews(profile)

and call them directly on the profile

    profile.exit.high_exits.low_pageviews


## Accounts, WebProperties, Profiles, and Goals ##

    > Legato::Management::Account.all(user)
    > Legato::Management::WebProperty.all(user)
    > Legato::Management::Profile.all(user)

## Other Parameters Can be Passed to a call to #results ##

  * :start_date - The date of the period you would like this report to start
  * :end_date - The date to end, inclusive
  * :limit - The maximum number of results to be returned
  * :offset - The starting index
  * :sort - metric/dimension to sort by
  * :quota_user - any arbitrary string that uniquely identifies a user (40 characters max)

## License ##

  (The MIT License)

  Copyright (c) 2012 Tony Pitale

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
