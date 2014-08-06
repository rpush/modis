require 'spec_helper'

module FindersSpec
  class User
    include Modis::Model
    self.namespace = 'users'

    attribute :name, :string
    attribute :age, :integer
  end

  class Consumer < User
  end

  class Producer < User
  end
end

describe Modis::Finders do
  let!(:model) { FindersSpec::User.create!(name: 'Ian', age: 28) }
  let(:found) { FindersSpec::User.find(model.id) }

  it 'finds by ID' do
    expect(found.id).to eq(model.id)
    expect(found.name).to eq(model.name)
    expect(found.age).to eq(model.age)
  end

  it 'raises an error if the record could not be found' do
    expect do
      FindersSpec::User.find(model.id + 1)
    end.to raise_error(Modis::RecordNotFound, "Couldn't find FindersSpec::User with id=#{model.id + 1}")
  end

  it 'does not flag an attribute as dirty on a found instance' do
    expect(found.id_changed?).to be false
  end

  describe 'all' do
    it 'returns all records' do
      m2 = FindersSpec::User.create!(name: 'Tanya', age: 30)
      m3 = FindersSpec::User.create!(name: 'Kyle', age: 32)
      expect(FindersSpec::User.all).to eq([model, m2, m3])
    end

    it 'does not return a destroyed record' do
      model.destroy
      expect(FindersSpec::User.all).to eq([])
    end
  end

  it 'identifies a found record as not being new' do
    expect(found.new_record?).to be false
  end

  describe 'Single Table Inheritance' do
    it 'returns the correct namespace' do
      expect(FindersSpec::Consumer.namespace).to eq('users')
      expect(FindersSpec::Consumer.absolute_namespace).to eq('modis:users')
      expect(FindersSpec::Producer.namespace).to eq('users')
      expect(FindersSpec::Producer.absolute_namespace).to eq('modis:users')
    end

    it 'returns instances of the correct class' do
      FindersSpec::Consumer.create!(name: 'Kyle')
      FindersSpec::Producer.create!(name: 'Tanya')

      models = FindersSpec::User.all

      ian = models.find { |model| model.name == 'Ian' }
      kyle = models.find { |model| model.name == 'Kyle' }
      tanya = models.find { |model| model.name == 'Tanya' }

      expect(ian).to be_kind_of(FindersSpec::User)
      expect(kyle).to be_kind_of(FindersSpec::Consumer)
      expect(tanya).to be_kind_of(FindersSpec::Producer)

      expect(FindersSpec::User.find(ian.id)).to be_kind_of(FindersSpec::User)
      expect(FindersSpec::User.find(kyle.id)).to be_kind_of(FindersSpec::Consumer)
      expect(FindersSpec::User.find(tanya.id)).to be_kind_of(FindersSpec::Producer)
    end
  end
end
