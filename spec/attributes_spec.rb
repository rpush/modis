require 'spec_helper'

module AttributesSpec
  class MockModel
    include Modis::Model

    attribute :name, :string, :default => 'Janet'
    attribute :age, :integer, :default => 60
    attribute :percentage, :float
    attribute :created_at, :time
    attribute :flag, :boolean
  end
end

describe Modis::Attributes do
  let(:model) { AttributesSpec::MockModel.new }

  it 'defines attributes' do
    model.name = 'bar'
    model.name.should == 'bar'
  end

  it 'applies an default value' do
    model.name.should eq 'Janet'
    model.age.should eq 60
  end

  it 'does not mark an attribute with a default as dirty' do
    model.name_changed?.should be_false
  end

  it 'raises an error for an unsupported attribute type' do
    expect do
      class AttributesSpec::MockModel
        attribute :unsupported, :symbol
      end
    end.to raise_error(Modis::UnsupportedAttributeType)
  end

  it 'assigns attributes' do
    model.assign_attributes(:name => 'bar')
    model.name.should eq 'bar'
  end

  it 'does not attempt to assign attributes that are not defined on the model'

  it 'coerces a :string attribute' do
    model.name = :bar
    model.name.should eq 'bar'
  end

  it 'coerces a :integer attribute' do
    model.age = "18"
    model.age.should eq 18
  end

  it 'coerces a :float attribute' do
    model.percentage = "18.6"
    model.percentage.should eq 18.6
  end

  it 'coerces a :time attribute' do
    now = Time.now
    model.created_at = now.to_s
    model.created_at.should be_kind_of(Time)
    model.created_at.to_s.should eq now.to_s
  end

  it 'does not attempt to coerce a value that is already a Time' do
    now = Time.now
    model.created_at = now
    model.created_at.should be_kind_of(Time)
    model.created_at.to_s.should eq now.to_s
  end

  it 'coerces a :boolean attribute' do
    now = Time.now
    model.flag = 'true'
    model.flag.should eq true
  end

  it 'coerces a :array attribute'
  it 'coerces a :hash attribute'
end
