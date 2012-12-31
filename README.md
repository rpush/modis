# RedisModel

ActiveModel + Redis with the aim to mimic ActiveRecord where possible.

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
  include RedisModel::Model
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
