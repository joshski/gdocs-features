require File.dirname(__FILE__) + '/spec_helper'

require 'feature_diff'
require 'google_docs_client'
require 'google_feature_store'
require 'file_feature_store'

describe FeatureDiff do

  it "should find updated features where versions are different" do
    local_feature = mock("local_feature", :path => '/the/same.feature', :version => '123')
    remote_feature = mock("remote_feature", :path => '/the/same.feature', :version => '124')
    local_store = mock("local_store", :features => [local_feature])
    remote_store = mock("remote_store", :features => [remote_feature])
    diff = FeatureDiff.new(local_store, remote_store)
    diff['/the/same.feature'].local.should == local_feature
    diff['/the/same.feature'].remote.should == remote_feature
  end

  it "should find remote only features" do
    remote_feature = mock("remote_feature", :path => '/remote/only.feature', :version => '123')
    local_store = mock("local_store", :features => [])
    remote_store = mock("remote_store", :features => [remote_feature])
    diff = FeatureDiff.new(local_store, remote_store)
    diff['/remote/only.feature'].remote.should == remote_feature
    diff['/remote/only.feature'].local.should be_nil
  end

  it "should find local only features" do
    local_feature = mock("local_feature", :path => '/local/only.feature', :version => '123')
    local_store = mock("local_store", :features => [local_feature])
    remote_store = mock("remote_store", :features => [])
    diff = FeatureDiff.new(local_store, remote_store)
    diff['/local/only.feature'].local.should == local_feature
    diff['/local/only.feature'].remote.should be_nil
  end

  it "should patch remote only features" do
    remote_feature = mock("remote_feature", :path => 'any/old.feature', :version => '789', :reformat => 'OK!')
    local_store = mock("local_store", :features => [])
    remote_store = mock("remote_store", :features => [remote_feature])
    diff = FeatureDiff.new(local_store, remote_store)
    local_store.should_receive(:create_feature).with('any/old.feature', '789', 'OK!')
    diff.patch
  end
  
  it "should patch updated features" do
    local_feature = mock("local_feature", :path => '/the/same.feature', :version => '123')
    remote_feature = mock("remote_feature", :path => '/the/same.feature', :version => '124')
    local_store = mock("local_store", :features => [local_feature])
    remote_store = mock("remote_store", :features => [remote_feature])
    diff = FeatureDiff.new(local_store, remote_store)
    local_feature.should_receive(:patch_from).with(remote_feature)
    diff.patch
  end
  
  it "should patch subset of differences" do
    local_one = mock("local_one", :path => '/the/one.feature', :version => '123')
    local_two = mock("local_two", :path => '/the/two.feature', :version => '123')
    remote_one = mock("remote_one", :path => '/the/one.feature', :version => 'higher')
    remote_two = mock("remote_two", :path => '/the/two.feature', :version => 'higher')
    local_store = mock("local_store", :features => [local_one, local_two])
    remote_store = mock("remote_store", :features => [remote_one, remote_two])
    diff = FeatureDiff.new(local_store, remote_store)
    local_one.should_receive(:patch_from).with(remote_one)    
    local_two.should_not_receive(:patch_from).with(remote_two)
    diff.patch([1])
  end

  it "should not patch local only features" do
    local_feature = mock("local_feature", :path => '/the/same.feature', :version => '123')
    local_store = mock("local_store", :features => [local_feature])
    remote_store = mock("remote_store", :features => [])
    diff = FeatureDiff.new(local_store, remote_store)
    local_feature.should_not_receive(:patch_from)
    diff.patch
  end

end

