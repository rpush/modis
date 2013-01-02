require 'spec_helper'

module FindersSpec
  class MockModel
    include Modis::Model

    attribute :name, :string
    attribute :age, :integer
  end
end

describe Modis::Finders do
  let!(:model) { FindersSpec::MockModel.create!(:name => 'Ian', :age => 28) }
  let(:found) { FindersSpec::MockModel.find(model.id) }

  it 'finds by ID' do
    found.id.should eq model.id
    found.name.should eq model.name
    found.age.should eq model.age
  end

  it 'raises an error if the record could not be found' do
    expect do
      FindersSpec::MockModel.find(model.id + 1)
    end.to raise_error(Modis::RecordNotFound, "Couldn't find FindersSpec::MockModel with id=#{model.id + 1}")
  end

  it 'does not flag an attribute as dirty on a found instance' do
    found.id_changed?.should be_false
  end

  describe 'all' do
    it 'returns all records' do
      m2 = FindersSpec::MockModel.create!(:name => 'Tanya', :age => 30)
      m3 = FindersSpec::MockModel.create!(:name => 'Kyle', :age => 32)

      FindersSpec::MockModel.all.should == [model, m2, m3]
    end

    it 'does not return a destroyed record' do
      model.destroy
      FindersSpec::MockModel.all.should == []
    end
  end


  it 'identifies a found record as not being new' do
    found.new_record?.should be_false
  end
end
