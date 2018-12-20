[![Build Status](https://secure.travis-ci.org/ileitch/modis.png?branch=master)](http://travis-ci.org/ileitch/modis)
[![Code Climate](https://codeclimate.com/github/ileitch/modis/badges/gpa.svg)](https://codeclimate.com/github/ileitch/modis)
[![Test Coverage](https://codeclimate.com/github/ileitch/modis/badges/coverage.svg)](https://codeclimate.com/github/ileitch/modis)

# Modis

ActiveModel + Redis with the aim to mimic ActiveRecord where possible.

## Requirements

Modis supports CRuby 2.2.2+ and jRuby 9k+

## Installation

Add this line to your application's Gemfile:

    gem 'modis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install modis

## Usage

```ruby
class MyModel
  include Modis::Model
  attribute :name, :string
  attribute :age, :integer
end

MyModel.create!(name: 'Ian', age: 28)
```

### all index

Modis, by default, creates an `all` index in redis in which it stores all the IDs for records created. As a result, a large amount of memory will be consumed if many ids are stored. The `all` index functionality can be turned off by using `enable_all_index`

```ruby
  class MyModel
    include Modis::Model
    enable_all_index false
  end
```

By disabling the `all` index functionality, the IDs of each record created won't be saved. As a side effect, using `all` finder method will raise a `IndexError` exception as we would not have enough information to fetch all records. See https://github.com/ileitch/modis/pull/7 for more context.

## Supported Features

TODO.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
