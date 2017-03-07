# Arendelle

Arendelle is a small gem with a distantly semantic name, used for initializing mostly frozen objects. If you've got kids, you probably already understand the name.

## Why?

There are a ton of great Struct-like libraries that focus on immutable values. Some (`ure`, for example) focus on performance and offer a similar interface to Struct for declaring dynamic classes. Others give you the full kitchen sink - featuring any type of object you need, with immutability built in.

Our use case was very simple, and yet we found ourselves repeatedly reaching for the same code snippet across multiple projects. We wanted something that offers a simple interface for initializing objects when using JSON.parse (which relies on `[]=` as a setter) or something we could occasionally use as a simple set-it-and-forget-it type of simple PORO.

So we built something lightweight, optimized for our current use case: `JSON.parse(json_string, object_class: Arendelle)`. When combined with JSON.parse it builds a clean javascript-object like interface for accessing deeply nested JSON, and for us, removed any concerns about "extra" things the code was doing.

Take a look at the source for yourself: you probably don't need our help to write this gem. The surface area is incredibly small. But given the utility we've found using this lib, we figured it couldn't hurt to put it out there. So, here you go, Internet. Enjoy.

**tl;dr**

Arendelle helps prevent accidentally mutating the state of a parsed JSON file or configuration class, while providing a javascript object-like interface for accessing deeply nested settings (when used in conjunction with `JSON.parse`). See usage for more details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arendelle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arendelle

## Usage

```ruby
  json = '{"user_settings":{"name":"Rob"}}'
  obj = JSON.parse(json, object_class: Arendelle)

  obj.user_settings.name
    => "Rob"

  # Variables are frozen after initialization
  obj.user_settings["name"] = "New Name"
    => FrozenVariableError: "Cannot modify frozen variable"

  # Values are frozen after being set
  name = obj.user_settings.name
  name << "Test"
    => RuntimeError: "can't modify frozen String"
    
  # We call these mostly frozen objects, because they aren't 100% immutable: they can have settings added, but not modified
  newobj = Arendelle.new(key1: "value1")
  newobj.key1
    => "value1"

  newobj["key2"] = "value2"
  newobj.key2
    => "value2"

  newobj["key1"] = "value3"
    => FrozenVariableError: "Cannot modify frozen variable"
```

```yaml
# api_keys.yml
defaults: &defaults
  cool_service:
    client_secret: <%= ENV["COOL_SERVICE_CLIENT_SECRET"] || "default_value" %>
```

```ruby
# Snippet from our "real-world" use case. For us, this is a replacement for the SettingsLogic gem.

# settings.rb
class Settings
  def self.api_keys
    Rails.application.config_for(:api_keys)
  end

  def self.values
    @values ||= JSON.parse(api_keys.to_json, object_class: Arendelle)
  end

  api_keys.each do |(k, _v)|
    define_singleton_method(k) do
      values.send(k)
    end
  end
end
```

```ruby
Settings.cool_service.client_secret
  => "default_value" # assuming the ENV var isn't set
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Wishlist

Currently, we're using this in conjunction with JSON.parse. In some situations, this is less than ideal, as we will rely on the recursive behavior of JSON.parse to ensure that each object is initialized appropriately - calling it as `JSON.parse({}.to_hash, object_class: Arendelle)` - which is one step too many.

Adding a `.build_from_hash` type of class method which efficiently handles recursively transforming hash isn't something we need often, but would be a nice-to-have.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/arendelle. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

