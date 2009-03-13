require File.dirname(__FILE__) + '/spec_helper'

require 'remote_features/dialogue'
require 'feature_diff'

describe RemoteFeatures::Dialogue do
  
  before do
    @local_store = mock("local_store")
    @remote_store = mock("remote_store")
    @io = mock("io", :puts => nil, :gets => "")
    @diff = mock("diff", :differences => {}, :patch => nil)
    @dialogue = RemoteFeatures::Dialogue.new(@io, @io, @local_store, @remote_store)
    FeatureDiff.stub!(:new).with(@local_store, @remote_store).and_return(@diff)
    
    @first_local_feature = mock("first_local_feature", :path => 'first/example.feature')
    @first_remote_feature = mock("first_remote_feature", :path => 'first/example.feature')
    @second_local_feature = mock("second_local_feature", :path => 'second/example.feature')
    @second_remote_feature = mock("second_remote_feature", :path => 'second/example.feature')
    @first_difference = Difference.new(@first_local_feature, @first_remote_feature, @local_store)
    @second_difference = Difference.new(@second_local_feature, @second_remote_feature, @local_store)
    @diff.stub!(:differences).and_return({
      @first_difference.path => @first_difference,
      @second_difference.path => @second_difference
    })
    @expected_diff_output = "1) updated - first/example.feature\n2) updated - second/example.feature"
  end
  
  it "should perform a feature diff" do
    FeatureDiff.should_receive(:new).with(@local_store, @remote_store).and_return(@diff)
    @dialogue.start
  end

  it "should render the results of the feature diff to the output" do
    @io.should_receive(:puts).with(@expected_diff_output)
    @dialogue.start
  end
  
  it "should prompt for patch numbers to apply" do
    @io.stub!(:puts).with(@expected_diff_output)
    @io.should_receive(:puts).with("Enter changes to apply, 'all' to apply all, or blank to exit")
    @dialogue.start
  end
  
  it "should accept a list of change numbers to apply" do
    @io.should_receive(:gets).and_return("1 67 99\n")
    @dialogue.start
  end
  
  it "should apply the selected patches" do
    @io.stub!(:gets).and_return("1 67 99\n")
    @diff.should_receive(:patch).with([1, 67, 99])
    @dialogue.start
  end

  it "should exit when there are no differences" do
    @diff.stub!(:differences).and_return({})
    Kernel.should_receive(:exit)
    @dialogue.start
  end
  
  it "should write a message when there are no differences" do
    @diff.stub!(:differences).and_return({})
    Kernel.stub!(:exit)
    @io.should_receive(:puts)
    @dialogue.start
  end
  
end