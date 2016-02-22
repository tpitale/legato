## Legato 0.7.0 ##

* Ensure `Filter` changes its `tracking_scope` when the query's scope is changed (by calls to `realtime`).

    *Tony Pitale*

## Legato 0.6.2 ##

* Add `filters` and `segment_filters` to query duplicating

    *Tony Pitale*

## Legato 0.6.1 ##

* Fix bug in `Query` where calling `results` did not retain previous basic options

    *Tony Pitale*

## Legato 0.6.0 ##

* Fix bug in `Query` where calling `results` after loading a collection would not load new data into the collection

    *Tony Pitale*

## Legato 0.5.2 ##

* Refactor `User.request` into a `Request` class
* Implement a query class for management requests
* Use `Request` for management with new query
* Add `quota_user` and `user_ip` on `User` for quota management

    *Tony Pitale*

## Legato 0.5.1 ##

*   `Legato::User#segments`
*   `Legato::User#goals`
*   README fixes to `filter` block syntax

    *Yuji Yamamoto*

## Legato 0.5.0 ##

*   Use Query#tracking_scope when converting `metrics`, `dimensions`, and `sort` list of parameters with `to_params`

    *Tony Pitale*

## Legato 0.4.0 ##

*   Adds support to lookup parent `web_property` or `account` from a child `profile`.

## Legato 0.3.3 ##

*   Adds `realtime` to `Legato::Model`, returns `Query` with tracking_scope set for the realtime API

    *Tony Pitale*

## Legato 0.3.2 ##

*   Fixes `sampling_level` not being properly sent in query params

    *Tony Pitale*

## Legato 0.3.1 ##

*   Fixes `realtime` on query to change the `tracking_scope` to 'rt' and return `self`, a `Query`

    *Tony Pitale*

## Legato 0.3.0 ##

*   Adds Management Goal under Profile
*   Adds Management Segment
*   Adds all `attributes` to WebProperty
*   Adds `legato` CLI

      Loads OAuth2 configuration and a legato user before dropping you into an
      `irb` session.

    *Tony Pitale*

## Legato 0.2.0 ##

*   Changed Query API for #metrics & #dimensions

      If you add metrics and dimensions to a query, it will not modify the
      parent (of the query) class's dimensions or metrics. Resolves issue #40.

    *Tony Pitale*

## Legato 0.1.0 ##

*   Added dynamic segment support from @etiennebarrie
*   Fixed some readme typos from PR by @juuso

## Legato 0.0.3 ##

*   Merged branch oauth-1-support

      If you pass on an OAuth 1 (not 2, the default) token from the OAuth gem, Legato will use that.
      Support for OAuth 2 is greater than OAuth 1 because of subtle and annoying differences in their operation.

    *Tony Pitale*

## Legato 0.0.2 ##

*   Specify request fields to slim down content returned

      Include request fields columnHeaders/name, rows, totalResults, totalsForAllResults

    *Patrick Roby*

*   Add total results and totals_for_all_results to Query#load

    *Patrick Roby*

*   Change :order to :sort to match GA

    *Patrick Roby*

*   Add webPropertyId to Management::Profile

    *Patrick Roby*

*   Allow explicitly setting the join character on filters

    *Tony Pitale*

*   1.8.7 Support

    *Tony Pitale*

## Legato 0.0.1 ##

*   Initial implementation

    *Tony Pitale*
