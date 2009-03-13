require File.dirname(__FILE__) + '/spec_helper'

require 'file_feature_store'
require 'google_feature_store'
require 'remote_features/cli/main'
require 'remote_features/dialogue'

describe RemoteFeatures::Cli::Main do
  before do
    $stdout.stub!(:puts)
    Kernel.stub!(:exit)
    RemoteFeatures::Dialogue.stub!(:new).and_return(mock("dialogue", :start => nil))
  end
  
  it "should create a file feature store with the first argument as the path" do
    file_store = mock("file_store")
    gdocs_store = mock("gdocs_store")
    FileFeatureStore.should_receive(:new).with("some/dir").and_return(file_store)
    GoogleFeatureStore.stub!(:new).and_return(gdocs_store)
    RemoteFeatures::Cli::Main.execute(["some/dir", "joshski:pass@docs.google.com"])
  end
  
  it "should create a google feature store when argument 2 matches user:pass@docs.google.com" do
    file_store = mock("file_store")
    gdocs_store = mock("gdocs_store")
    client = mock("client")
    FileFeatureStore.stub!(:new).and_return(file_store)
    GoogleDocsClient.should_receive(:new).with("joshski", "pass").and_return(client)
    GoogleFeatureStore.should_receive(:new).with(client).and_return(gdocs_store)
    RemoteFeatures::Cli::Main.execute(["some/dir", "joshski:pass@docs.google.com"])
  end
  
  describe "with invalid arguments", :shared => true do
    it "should show usage" do
      [FileFeatureStore, GoogleFeatureStore, GoogleDocsClient].each { |c| c.stub!(:new) }
      $stdout.should_receive(:puts).with("Usage: remotefeatures <directory> <user:password@host>")
      RemoteFeatures::Cli::Main.execute(@args)
    end

    it "should not create anything" do
      [FileFeatureStore, GoogleFeatureStore, GoogleDocsClient].each do |c|
        c.should_not_receive(:new)
      end
      RemoteFeatures::Cli::Main.execute(@args)
      RemoteFeatures::Dialogue.should_not_receive(:new)
    end    
  end
  
  describe "with no arguments" do
    before { @args = [] }
    it_should_behave_like "with invalid arguments"
  end
  
  describe "with only first argument" do
    before { @args = ["."] }
    it_should_behave_like "with invalid arguments"
  end
  
  describe "with three arguments" do
    before { @args = ["valid", "valid:valid@valid.com", "invalid"] }
    it_should_behave_like "with invalid arguments"
  end
  
  describe "with invalid url argument" do
    before { @args = ["valid", "in-valid@valid.com"] }
    it_should_behave_like "with invalid arguments"
  end

end