require File.dirname(__FILE__) + '/spec_helper'

require 'google_docs_client'

describe GoogleDocsClient do

  it "should get the documents feed as a resource" do
    client = GoogleDocsClient.new("restapitest", "testrestapi")
    resource = mock("resource")
    GoogleResource.should_receive(:new).and_return(resource)
    resource.should_receive(:get).and_return("OK")
    client.documents_feed.get.to_s.should == "OK"
  end

  describe "connected to Google" do

    before do
      @client = GoogleDocsClient.new("restapitest@googlemail.com", "testrestapi")
    end

    it "should get the documents feed" do
      @client.documents_feed.get.to_s.should =~ /<feed/
    end

    it "should get folders" do
      @client.folders.get.to_s.should =~ /<feed/
    end
    
  end

end

