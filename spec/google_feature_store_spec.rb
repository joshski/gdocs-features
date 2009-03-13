require File.dirname(__FILE__) + '/spec_helper'

require 'google_feature_store'
require 'google_docs_client'

def relative_path(path)
  File.join(File.dirname(__FILE__), path)
end

def stub_folders_feed
  mock("folders_feed", :get => File.readlines(relative_path('./stubs/folders.atom.xml')).map {|l| l.rstrip})
end

def stub_documents_feed
  mock("documents_feed", :get => File.readlines(relative_path('./stubs/documents.atom.xml')).map {|l| l.rstrip})
end

describe GoogleFeatureStore do

  describe "creating features from feed" do

    before do
      @body = "happy"
      client = mock("client",
        :folders => stub_folders_feed,
        :documents_feed => stub_documents_feed,
        :document_body => mock("document_body", :get => @body))
      @features = GoogleFeatureStore.new(client).features
      @banana = @features.first
    end

    it "should expose a list of features" do
      @features.size.should == 1
    end

    it "should expose a body from a resource" do
      @banana.body.should == [@body]
    end

    it "should expose a body from the entry" do
      @banana.title.should == "banana"
    end

    it "should expose a version from the entry modified date" do
      @banana.version.should == "2009-02-19T23:36:34.402Z"
    end

  end

  it "should get a folder hierarchy from a feed" do
    client = mock("client", :folders => stub_folders_feed, :documents_feed => stub_documents_feed)
    folders = GoogleFeatureStore.new(client).folders
    yellow = "http://docs.google.com/feeds/documents/private/full/folder%3Aa58446b0-772d-4ff7-bcb5-eb280b0cf53a"
    folders[yellow].should == "fruit/yellow"
  end

  it "should attach paths to features" do
    client = mock("client", :folders => stub_folders_feed, :documents_feed => stub_documents_feed)
    features = GoogleFeatureStore.new(client).features
    features.find_all { | f | f.path == "fruit/yellow/banana.feature" }.size.should == 1
  end
  
end

