require 'spec_helper'

module FindersSpec
  class MockModel
    include Modis::Model

    attribute :name, String
    attribute :age, Integer
  end
end

describe Modis::Finders do
  let!(:model) { FindersSpec::MockModel.create!(:name => 'Ian', :age => 28) }
  let(:found) { FindersSpec::MockModel.find(model.id) }

  it 'finds by ID' do
    found.id.should eq model.id.to_s
    found.name.should eq model.name
    found.age.should eq model.age.to_s
  end

  it 'raises an error if the record could not be found' do
    expect do
      FindersSpec::MockModel.find(model.id + 1)
    end.to raise_error(Modis::RecordNotFound, "Couldn't find FindersSpec::MockModel with id=#{model.id + 1}")
  end

  it 'does not flag an attribute as dirty on a found instance' do
    found.id_changed?.should be_false
  end
end
