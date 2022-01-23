# Rapporteur changelog

[![Gem Version](http://img.shields.io/gem/v/rapporteur.svg?style=flat)](http://rubygems.org/gems/rapporteur)
[![Test and Release](https://github.com/envylabs/rapporteur/actions/workflows/tests.yml/badge.svg)](https://github.com/envylabs/rapporteur/actions/workflows/tests.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/8c498efff627b93db4b9/maintainability)](https://codeclimate.com/github/envylabs/rapporteur/maintainability)
[![Inline docs](http://inch-ci.org/github/envylabs/rapporteur.svg?branch=master)](http://inch-ci.org/github/envylabs/rapporteur)

## [HEAD][] / unreleased

* Add support for Rails 7.0.

## [3.7.2][] / 2021-06-22

* Test support for Rails 6.1.

## [3.7.1][] / 2020-09-25

* Fix a Ruby 2.7 keyword argument deprecation warning in MessageList.

## [3.7.0][] / 2020-01-02

* Add and test support for Rails 6.0. This also drops explicit testing of Rails
  5.0 and 5.1 as they are no longer officially maintained.

## [3.6.4][] / 2019-04-04

* Maintenance release, no functional changes.

## [3.6.3][] / 2018-10-03

* Ensure the `Rapporteur::ApplicationController` is loaded and utilized.

## [3.6.2][] / 2018-09-11

* Allow i18n 1.x versions as a dependency.

## [3.6.1][] / 2018-05-20

* Convert Checker#messages and #errors into Thread-local variables. See
  [#17](https://github.com/envylabs/rapporteur/issues/17) and
  [#18](https://github.com/envylabs/rapporteur/issues/18), thanks to
  [nevinera][].

## [3.6.0][] / 2017-06-10

* Add `expires_now` to the Rails controller's status response. This ensures the
  `Cache-Control` header instructs the client to not cache the response and
  avoids the `ETag` header being generated.

## [3.5.1][] / 2016-02-08

* Fix automatic Rapporteur mount detection logic under Rails 4.0 and 4.1. The
  mapper constraints used in 4.2 were not used in 4.0 and 4.1, causing a method
  reference error. See [#15](https://github.com/envylabs/rapporteur/issues/15),
  thanks to [sshaw][].

## [3.5.0][] / 2016-01-28

* Add a backward-compatible fallback to auto-mount the `Rapporteur::Engine` in
  a Rails application and deprecation warning if it is not explicitly mounted
  by the application.
* Require the parent application to explicitly mount the `Rapporteur::Engine`
  in their Rails application. This adds mount point flexibility at the cost of
  configuration.
* Change ActiveRecord to use a more database agnostic `select_value` query to
  determine availability. See
  [#12](https://github.com/envylabs/rapporteur/issues/12).

## [3.4.0][] / 2016-01-06

* Update the route generation code to no longer use a `.routes` method that
  becomes private in Rails 5. Thanks to [lsylvester][].

## [3.3.0][] / 2015-02-03

* Remove the customized Rapporteur::Responder (an ActionController::Responder)
  since responders were removed from Rails core in version 4.2 and inline the
  logic into the StatusesController.
* Register Rapporteur::Engine routes for Rails 4.2 support.
* Auto-mount the engine routes and force definition of an application `status`
  route for backward compatibility. Otherwise, developers would seemingly need
  to either manually mount the engine or define an application-level named
  route for the status endpoint.

## [3.2.0][] / 2015-02-02

* Update the Rails route definition to force (and default) a JSON format. The
  intent is to fix an issue where Rails auto-appended a `(.:format)` segment to
  the fixed route and broke `/status.json` route matching. See
  [#9](https://github.com/envylabs/rapporteur/issues/9).

## [3.1.0][] / 2014-07-03

* Remove the explicit railties dependency (was at `'>= 3.1', '< 4.2'`). This
  allows Rapporteur to be used in Sinatra applications without loading
  railties, actionpack, etc.
* Update the packaged RSpec matchers to allow matching against regular
  expressions or strings.
* Add support for deprecation-less RSpec 3 by introducing rapporteur/rspec3.
* Removed official support for Rails 3.1.x, as it is no longer supported by the
  Rails core team.

## [3.0.2][] / 2014-05-17

* Test for and allow compatibility with railties 4.1.

## [3.0.1][] / 2013-08-23

* Add back missing support for I18n interpolated values which was lost with the
  customized message lists.

## [3.0.0][] / 2013-08-23

* Fix/add Ruby 1.8 compatibility. Because this library was built to work with
  Rails 3.1 and 3.2 (as well as 4.0), not supporting Ruby 1.8 was dishonest.
  That has now been rectified.
* Update message and error handling to allow for both I18n/Proc/String support
  for both types of messages, by replacing ActiveModel::Errors with a local
  message list. This provides better consistency between the error message and
  success message implementations.
* Use a customized check list registry to ensure order persistence and object
  uniqueness across Ruby versions.
* Upgrade Combustion development support gem to fix deprecations in Rails 4.0.

### :boom: Backward incompatible changes

* Attributes may now have multiple success messages bound to them for
  reporting. This means that there are now, possibly, more than one message per
  key.

## [2.1.0][] / 2013-06-28

* Update the gemspec to allow for Rails 4.0 environments.
* Update the packaged Responder to properly handle Rails 4.0.
* Fix deprecation notice for Checker.clear.

## [2.0.1][] / 2013-05-31

* Fix NoMethodError in CheckerDeprecations#clear.

## [2.0.0][] / 2013-05-31

* Removed active_model_serializers dependency.
* Extracted time and revision checks into Checks::TimeCheck and
  Checks::RevisionCheck, and applied them as the default checks.
* Updated Checker#add_error to allow for I18n interpolated values.
* Updated Checker#add_check to take a block in addition to a lambda or object
  that responds to #call.
* Added Checker#halt! which checks can call to short-circuit processing of any
  further checks.

### :boom: Backward incompatible changes

* Flattened the messages key in the JSON response. All messages are now
  included at the top level of the hash.
* It's now possible to remove all checks by calling Checker#clear. This
  includes the default TimeCheck and RevisionCheck checks.
* Simplified the I18n scope to "rapporteur.errors.{attribute}.{key}". This
  means that Checker#add_error now takes at least 2 arguments, similarly to
  ActiveModel::Errors#add.
* Added a facade for all Checker interaction. Clients should not use
  Rapporteur::Checker.add_check et al, in favor of using Rapporteur.add_check.

## [1.1.0][] / 2013-05-30

* Add the ability to define custom successful response messages via
  add_message. This allows Check authors to relay automated information forward
  to other external systems.

## [1.0.1][] / 2013-05-20

* Improve the gemspec's minimum runtime- and development-dependency version
  accuracies.

## 1.0.0 / 2013-05-19

* Initial public release.


[lsylvester]: https://github.com/lsylvester
[nevinera]: https://github.com/nevinera
[sshaw]: https://github.com/sshaw

[1.0.1]: https://github.com/envylabs/rapporteur/compare/v1.0.0...v1.0.1
[1.1.0]: https://github.com/envylabs/rapporteur/compare/v1.0.1...v1.1.0
[2.0.0]: https://github.com/envylabs/rapporteur/compare/v1.1.0...v2.0.0
[2.0.1]: https://github.com/envylabs/rapporteur/compare/v2.0.0...v2.0.1
[2.1.0]: https://github.com/envylabs/rapporteur/compare/v2.0.1...v2.1.0
[3.0.0]: https://github.com/envylabs/rapporteur/compare/v2.1.0...v3.0.0
[3.0.1]: https://github.com/envylabs/rapporteur/compare/v3.0.0...v3.0.1
[3.0.2]: https://github.com/envylabs/rapporteur/compare/v3.0.1...v3.0.2
[3.1.0]: https://github.com/envylabs/rapporteur/compare/v3.0.2...v3.1.0
[3.2.0]: https://github.com/envylabs/rapporteur/compare/v3.1.0...v3.2.0
[3.3.0]: https://github.com/envylabs/rapporteur/compare/v3.2.0...v3.3.0
[3.4.0]: https://github.com/envylabs/rapporteur/compare/v3.3.0...v3.4.0
[3.5.0]: https://github.com/envylabs/rapporteur/compare/v3.4.0...v3.5.0
[3.5.1]: https://github.com/envylabs/rapporteur/compare/v3.5.0...v3.5.1
[3.6.0]: https://github.com/envylabs/rapporteur/compare/v3.5.1...v3.6.0
[3.6.1]: https://github.com/envylabs/rapporteur/compare/v3.6.0...v3.6.1
[3.6.2]: https://github.com/envylabs/rapporteur/compare/v3.6.1...v3.6.2
[3.6.3]: https://github.com/envylabs/rapporteur/compare/v3.6.2...v3.6.3
[3.6.4]: https://github.com/envylabs/rapporteur/compare/v3.6.3...v3.6.4
[3.7.0]: https://github.com/envylabs/rapporteur/compare/v3.6.4...v3.7.0
[3.7.1]: https://github.com/envylabs/rapporteur/compare/v3.7.0...v3.7.1
[3.7.2]: https://github.com/envylabs/rapporteur/compare/v3.7.1...v3.7.2
[HEAD]: https://github.com/envylabs/rapporteur/compare/v3.7.2...master
