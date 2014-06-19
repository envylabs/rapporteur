# Rapporteur changelog

## [HEAD][unreleased] / unreleased

* Removed official support for Rails 3.1.x, as it is no longer supported by the
  Rails core team.

## [3.0.2][v3.0.2] / 2014-05-17

* Test for and allow compatibility with railties 4.1.

## [3.0.1][v3.0.1] / 2013-08-23

* Add back missing support for I18n interpolated values which was lost with the
  customized message lists.

## [3.0.0][v3.0.0] / 2013-08-23

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

## [2.1.0][v2.1.0] / 2013-06-28

* Update the gemspec to allow for Rails 4.0 environments.
* Update the packaged Responder to properly handle Rails 4.0.
* Fix deprecation notice for Checker.clear.

## [2.0.1][v2.0.1] / 2013-05-31

* Fix NoMethodError in CheckerDeprecations#clear.

## [2.0.0][v2.0.0] / 2013-05-31

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

## [1.1.0][v1.1.0] / 2013-05-30

* Add the ability to define custom successful response messages via
  add_message. This allows Check authors to relay automated information forward
  to other external systems.

## [1.0.1][v1.0.1] / 2013-05-20

* Improve the gemspec's minimum runtime- and development-dependency version
  accuracies.

## 1.0.0 / 2013-05-19

* Initial public release.


[unreleased]: https://github.com/codeschool/rapporteur/compare/v3.0.2...master
[v3.0.2]: https://github.com/codeschool/rapporteur/compare/v3.0.1...v3.0.2
[v3.0.1]: https://github.com/codeschool/rapporteur/compare/v3.0.0...v3.0.1
[v3.0.0]: https://github.com/codeschool/rapporteur/compare/v2.1.0...v3.0.0
[v2.1.0]: https://github.com/codeschool/rapporteur/compare/v2.0.1...v2.1.0
[v2.0.1]: https://github.com/codeschool/rapporteur/compare/v2.0.0...v2.0.1
[v2.0.0]: https://github.com/codeschool/rapporteur/compare/v1.1.0...v2.0.0
[v1.1.0]: https://github.com/codeschool/rapporteur/compare/v1.0.1...v1.1.0
[v1.0.1]: https://github.com/codeschool/rapporteur/compare/v1.0.0...v1.0.1
