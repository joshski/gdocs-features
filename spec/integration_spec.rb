require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/temp_file_system'

require 'google_feature_store'
require 'google_docs_client'
require 'file_feature_store'
require 'feature_diff'

describe "integration with Google" do

    before(:all) do
      @client = GoogleDocsClient.new("restapitest@googlemail.com", "testrestapi")
      @remote_store = GoogleFeatureStore.new(@client)
      @features = @remote_store.features
      @fs = TempFileSystem.new(
        'fruit/yellow/banana.feature' => %{#version:123
          Some other text
        }
      )
    end
    
    after(:all) do
      @fs.destroy
    end

    it "should get features" do
      @features.size.should > 1
      banana = @features.find { |f| f.title == "banana" }
      banana.path.should == 'fruit/yellow/banana.feature'
    end
  
    it "should patch differences" do
      local_store = FileFeatureStore.new(@fs.root)
      diff = FeatureDiff.new(local_store, @remote_store)
      banana = diff["fruit/yellow/banana.feature"]
      banana.local.version.should == "123"
      banana.remote.version.should_not == "123"
      banana.patch
      banana.local.version.should == banana.remote.version
    end
  
end