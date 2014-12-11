$:.unshift('.')
require 'benchmark/bench'

class User
  include Modis::Model

  attribute :name, :string
  attribute :age, :integer
  attribute :percentage, :float
  attribute :created_at, :timestamp
  attribute :flag, :boolean
  attribute :array, :array
  attribute :hash, :hash
  attribute :string_or_hash, [:string, :hash]

  index :name
end

user = User.create!(name: 'Test', age: 30, percentage: 50.0, created_at: Time.now,
                    flag: true, array: [1, 2, 3], hash: {k: :v}, string_or_hash: "an string")
user_id = user.id
user_name = user.name

n = 1000

Bench.run do |b|
  b.report(:find) do
    n.times do
      User.find(user_id)
    end
  end

  b.report(:where) do
    n.times do
      User.where(name: user_name)
    end
  end
end
