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
  include Modis::Models
  attribute :name, String
  attribute :age, Integer
end

MyModel.create!(:name => 'Ian', :age => 28)
```

## Supported Features

TODO.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
