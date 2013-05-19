# Codeschool::Status [![Build Status](https://magnum.travis-ci.com/codeschool/codeschool-status.png?token=U1RMnDeNpXqKyFsQVEWy&branch=concern_separation)](https://magnum.travis-ci.com/codeschool/codeschool-status)

This gem provides a singular, status-checking endpoint to your application. The
endpoint provides a JSON response with either an HTTP 200 or an HTTP 500
response, depending on the current application environment.

When the environment tests successfully, an HTTP 200 response is returned with
the current application Git revision and server time:

```json
{
  "revision": "906731e6467ea381ba5bc70f103b85ed4178fee7",
  "time": "2013-05-19T05:38:46Z"
}
```

When an application validation fails, an HTTP 500 response is returned with a
collection of error messages, similar to the default Rails responders for model
validations:

```json
{
  "errors": {
    "base": ["The application database is inaccessible or unavailable"]
  }
}
```

## Installation

Add this line to your application's Gemfile:

    gem 'codeschool-status'

And then execute:

    $ bundle

## Usage

### Customizing the revision

If you need to customize the way in which the current application revision is
calculated (by default it runs a `git rev-parse HEAD`), you may do so by
modifying the necessary environment file in your Rails application:

```ruby
# config/environments/production.rb

MyApplication.configure do
  # ... config.settings ...

  config.to_prepare do
    Codeschool::Status::Revision.current = "revision123"
  end

  # ... config.settings ...
end
```

You may pass a String or a callable object (Proc) to `.current=` and it will be
executed and memoized. Useful examples of this are:

```ruby
# Read a Capistrano REVISION file
Codeschool::Status::Revision.current = Rails.root.join("REVISION").read.strip

# Force a particular directory and use Git
Codeschool::Status::Revision.current = `cd "#{Rails.root}" && git rev-parse HEAD`.strip

# Use an ENV variable (Heroku)
Codeschool::Status::Revision.current = ENV["REVISION"]

# Do some crazy calculation
Codeschool::Status::Revision.current = lambda { MyRevisionCalculator.execute! }
```

### Customizing the error messages

The error messages displayed in the event that application validations fail are
all collected through I18n. There are default localization strings provided
with the gem, but you may override them as necessary, simply by redefining them
in a locales file within your local application.

For example, to override the database check failure message:

```yaml
en:
  activemodel:
    errors:
      models:
        codeschool/status/checker:
          attributes:
            base:
              database_unavailable: "Something went wrong"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
