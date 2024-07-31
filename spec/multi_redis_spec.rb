# frozen_string_literal: true

module MultiRedisSpec
  class DefaultUserModel
    include Modis::Model

    attribute :name, :string
  end

  class CustomUserModel
    include Modis::Model
    self.modis_connection = :custom

    attribute :name, :string
  end
end

describe 'Multiple redis support' do
  before do
    Modis.redis_options = {
      default: { url: 'redis://localhost:6379/0' },
      custom: { url: 'redis://localhost:6379/1' }
    }
  end

  it 'uses the default redis connection' do
    expect(Modis).to receive(:with_connection).with(:default).at_least(3).times.and_call_original
    user = MultiRedisSpec::DefaultUserModel.create!(name: 'Ian')

    expect(Modis).to receive(:with_connection).with(:default).at_least(3).times.and_call_original
    MultiRedisSpec::DefaultUserModel.find(user.id)
  end

  it 'uses the specified redis connection when set up' do
    expect(Modis).to receive(:with_connection).with(:custom).at_least(3).times.and_call_original
    user = MultiRedisSpec::CustomUserModel.create!(name: 'Tanya')

    expect(Modis).to receive(:with_connection).with(:custom).at_least(3).times.and_call_original
    MultiRedisSpec::CustomUserModel.find(user.id)
  end
end

describe 'backwards compatibility' do
   before do
    Modis.redis_options = {
      url: 'redis://localhost:6379/0'
    }
  end

  it 'uses the default redis connection' do
    expect(Modis).to receive(:with_connection).with(:default).at_least(3).times.and_call_original
    MultiRedisSpec::DefaultUserModel.create!(name: 'Ian')
  end
end
