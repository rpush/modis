$LOAD_PATH.unshift('.')
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

n = 10_000

Bench.run do |b|
  b.report(:create) do
    n.times do
      User.create!(name: 'Test', age: 30, percentage: 50.0, created_at: Time.now,
      flag: true, array: [1, 2, 3], hash: { k: :v }, string_or_hash: "an string")
    end
  end

  b.report(:save) do
    n.times do
      user = User.new
      user.name = 'Test'
      user.age = 30
      user.percentage = 50.0
      user.created_at = Time.now
      user.flag = true
      user.array = [1, 2, 3]
      user.hash = { k: :v }
      user.string_or_hash = "an string"
      user.save!
    end
  end
end
