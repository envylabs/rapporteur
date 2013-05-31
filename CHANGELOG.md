# Rapporteur changelog

## [HEAD][unreleased] / unreleased

* Removed active_model_serializers dependency.
* Extracted time and revision checks into Checks::TimeCheck and
  Checks::RevisionCheck, and applied them as the default checks.
* Updated Checker#add_error to allow for I18n interpolated values.
* Updated Checker#add_check to take a block in addition to a lambda or object
  that responds to #call.

### :boom: Backward incompatible changes

* Flattened the messages key in the JSON response. All messages are now
  included at the top level of the hash.
* It's now possible to remove all checks by calling Checker#clear. This
  includes the default TimeCheck and RevisionCheck checks.

## [1.1.0][v1.1.0] / 2013-05-30

* Add the ability to define custom successful response messages via
  add_message. This allows Check authors to relay automated information forward
  to other external systems.

## [1.0.1][v1.0.1] / 2013-05-20

* Improve the gemspec's minimum runtime- and development-dependency version
  accuracies.

## 1.0.0 / 2013-05-19

* Initial public release.


[unreleased]: https://github.com/codeschool/rapporteur/compare/v1.1.0...master
[v1.1.0]: https://github.com/codeschool/rapporteur/compare/v1.0.1...v1.1.0
[v1.0.1]: https://github.com/codeschool/rapporteur/compare/v1.0.0...v1.0.1
