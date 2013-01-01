require 'spec_helper'

module AttributesSpec
  class MockModel
    include Modis::Model

    attribute :name, String
    attribute :age, Integer
    attribute :percentage, Float
    attribute :created_at, Time
  end
end

describe Modis::Attributes do
  let(:model) { AttributesSpec::MockModel.new }

  it 'defines attributes' do
    model.name = 'bar'
    model.name.should == 'bar'
  end

  it 'exposes the attributes defined on the model' do
    AttributesSpec::MockModel.attributes.should ==
      { :id => Integer, :name => String, :age => Integer, :percentage => Float,
        :created_at => Time }
  end

  it 'raises an error for an unsupported attribute type' do
    expect do
      class AttributesSpec::MockModel
        attribute :unsupported, Symbol
      end
    end.to raise_error(Modis::UnsupportedAttributeType)
  end

  it 'assigns attributes' do
    model.assign_attributes(:name => 'bar')
    model.name.should eq 'bar'
  end

  it 'coerces a String attribute' do
    model.name = :bar
    model.name.should eq 'bar'
  end

  it 'coerces a Integer attribute' do
    model.age = "18"
    model.age.should eq 18
  end

  it 'coerces a Float attribute' do
    model.percentage = "18.6"
    model.percentage.should eq 18.6
  end

  it 'coerces a Time attribute' do
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
end
