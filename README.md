# Rapporteur (rap-or-TUHR)

[![Gem Version](http://img.shields.io/gem/v/rapporteur.svg?style=flat)](http://rubygems.org/gems/rapporteur)
[![Build Status](http://img.shields.io/travis/envylabs/rapporteur/master.svg?style=flat)](https://travis-ci.org/envylabs/rapporteur)
[![Code Climate](http://img.shields.io/codeclimate/github/envylabs/rapporteur.svg?style=flat)](https://codeclimate.com/github/envylabs/rapporteur)
[![Inline docs](http://inch-ci.org/github/envylabs/rapporteur.svg?branch=master)](http://inch-ci.org/github/envylabs/rapporteur)


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
collection of error messages, similar to the Rails < 4.2 responders for model
validations:

```json
{
  "errors": {
    "database": ["The application database is inaccessible or unavailable"]
  }
}
```

## Installation

To install, add this line to your application's Gemfile:

```ruby
gem 'rapporteur'
```

And then execute:

```bash
$ bundle install
```

### Supported environments

Supported Ruby versions:

* MRI 2.4
* MRI 2.3
* MRI 2.2

Supported frameworks:

* Rails 5.x.
* Rails 4.2+.
* Sinatra 2.x.
* Sinatra 1.x.

Older versions of Ruby and frameworks may also work with this library, however
they are not officially supported.

## Usage

By default, there are no application checks that run and the status endpoint
simply reports the current application revision and time. This is useful for a
basic connectivity check to be watched by a third party service like Pingdom
for a very simple, non-critical application.

You may optionally use any of the pre-defined checks (such as the ActiveRecord
connection check) to expand the robustness of the status checks. Adding a check
will execute that check each time the status endpoint is requested, so be
somewhat wary of doing _too_ much. See more in the [Adding checks
section](#adding-checks), below.

Further, you can define your own checks which could be custom to your
application or environment and report their own, unique errors.  The only
requirement is that the check objects are callable (respond to `#call`, like a
Proc). See more in the [Creating custom checks
section](#creating-custom-checks), below.

### Usage in a Rails application

If you're running in a Rails environment, then the included Rails Engine should
automatically get required and loaded. However, you will need to instruct your
application where to mount the status endpoint. In your `config/routes.rb`, add
a `mount` at the endpoint you desire:

```ruby
Rails.application.routes.draw do
  mount Rapporteur::Engine, at: '/status'
end
```

This will mount the Rapporteur status endpoint at `/status` where it will
listen for and respond to JSON requests (`/status.json`, for example).

### Usage in a Rack (non-Rails) application

If you're running in a non-Rails, Rack environment (e.g. Sinatra), you can
`require "rapporteur"` and use the status generator directly from your own
endpoints.

So, here is an example usage in Sinatra:

```ruby
require "rapporteur"
require "sinatra/base"

class MyApp < Sinatra::Base
  get "/status.json" do
    content_type :json
    status(result.errors.empty? ? 200 : 500)
    body Rapporteur.run.as_json.to_json
  end
end
```

Require `rapporteur` and then, at some point, call `Rapporteur.run` to execute
the configured checks. `as_json` will convert the result of the `run` into a
Hash which is ready for JSON generation. At that point, do whatever you need to
do with the Hash to have your framework of choice generate and respond with
JSON.

## Customization

### Adding checks

This gem ships with the following checks tested and packaged:

* **Rapporteur::Checks::ActiveRecordCheck** - Performs a trivial test
  of the current `ActiveRecord::Base.connection` to ensure basic database
  connectivity.

To add checks to your application, define the checks you'd like to run in your
environment or application configuration files or initializers, such as:

```ruby
# config/initializers/rapporteur.rb
Rapporteur.add_check(Rapporteur::Checks::ActiveRecordCheck)
```

Or, make an environment specific check with:

```ruby
# config/environments/production.rb
MyApplication.configure do
  config.to_prepare do
    Rapporteur.add_check(Rapporteur::Checks::ActiveRecordCheck)
  end
end
```

### Creating custom checks

It is simple to add a custom check to the status endpoint. All that is required
is that you give the checker an object that is callable. In your object, simply
check for the state of the world that you're interested in, and if you're not
happy with it, add an error to the given `checker` instance:

```ruby
# config/initializers/rapporteur.rb

# Define a simple check as a block:
Rapporteur.add_check do |checker|
  checker.add_message(:paid, "too much")
end

# Make and use a reusable Proc or lambda:
my_proc_check = lambda { |checker|
  checker.add_error(:luck, :bad) if rand(2) > 0
  checker.add_message(:luck, :good)
}
Rapporteur.add_check(my_proc_check)

# Package a check into a Class:
class MyClassCheck
  def self.call(checker)
    @@counter ||= 0
    checker.add_error(:count, :exceeded) if @@counter > 50
  end
end
Rapporteur.add_check(MyClassCheck)
```

Certainly, the definition and registration of the checks do not need to occur
within the same file, but you get the idea. Also: Please make your checks more
useful than those defined above. ;)

You could create a checker for your active Redis connection, Memcached
connections, disk usage percentage, process count, memory usage, or really
anything you like. Again, because these checks get executed every time the
status endpoint is called, **be mindful of the tradeoffs when making a check that
may be resource intensive**.

### Customizing the revision

If you need to customize the way in which the current application revision is
calculated (by default it runs a `git rev-parse HEAD`), you may do so by
modifying the necessary environment file or creating an initializer in your
Rails application:

```ruby
# config/initializers/rapporteur.rb
Rapporteur::Revision.current = "revision123"
```

```ruby
# config/environments/production.rb
MyApplication.configure do
  config.to_prepare do
    Rapporteur::Revision.current = "revision123"
  end
end
```

You may pass a String or a callable object (Proc) to `.current=` and it will be
executed and memoized. Useful examples of this are:

```ruby
# Read a Capistrano REVISION file
Rapporteur::Revision.current = Rails.root.join("REVISION").read.strip

# Force a particular directory and use Git
Rapporteur::Revision.current = `cd "#{Rails.root}" && git rev-parse HEAD`.strip

# Use an ENV variable (Heroku Bamboo Stack)
Rapporteur::Revision.current = ENV["REVISION"]

# Do some crazy calculation
Rapporteur::Revision.current = lambda { MyRevisionCalculator.execute! }
```

### Customizing the messages

The success and error messages displayed in the event that application
validations pass or fail are all optionally passed through I18n. There are
default localization strings provided with the gem, but you may override them
as necessary, by simply redefining the proper locale keys in a locale file
within your local application.

For example, to override the database check failure message:

```yaml
# /config/locales/en.yml
en:
  rapporteur:
    errors:
      database:
        unavailable: "Something went wrong"
```

If you created a custom checker which reports the current sky color, for
example, and wanted the success messages to be localized, you could do the
following:

```ruby
# /config/initializers/rapporteur.rb
sky_check = lambda { |checker| checker.add_message(:sky, :blue) }
Rapporteur.add_check(sky_check)
```

```yaml
# /config/locales/fr.yml
fr:
  rapporteur:
    messages:
      sky:
        blue: "bleu"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
