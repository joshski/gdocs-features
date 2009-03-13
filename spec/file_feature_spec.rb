require File.dirname(__FILE__) + '/spec_helper'

require 'file_feature'

describe FileFeature do

  before do
    @feature = FileFeature.new(File.dirname(__FILE__), "stubs/example.feature")
  end

  it "should expose a body from the file" do
    @feature.body.first.should == "Feature: Example"
  end

  it "should expose a title from the filename" do
    @feature.title.should == "example"
  end

  it "should get the version from the first line of comment in the file" do
    @feature.version.should == "123"
  end

end
