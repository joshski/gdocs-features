require File.dirname(__FILE__) + '/spec_helper'

require 'google_authorization'

describe GoogleAuthorization do

  it "should post to the authorization resource once on first access of header" do
    RestClient.stub!(:post).and_return("xxxAuth=ABC")
    auth = GoogleAuthorization.new("email", "pass")
    auth.header.should == "GoogleLogin auth=ABC"
    RestClient.stub!(:post).and_raise "shouldn't post twice"
    auth.header
  end

  it "should post the correct url and parameters when authorizing" do
    url = "https://www.google.com/accounts/ClientLogin"
    params = { "accountType" => "HOSTED_OR_GOOGLE", "Email" => "email", "Passwd" => "pass", "service" => "writely" }
    RestClient.should_receive(:post).with(url, hash_including(params))
    GoogleAuthorization.new("email", "pass").authorize
  end

  it "should authorize with a real rest client" do
    GoogleAuthorization.new("restapitest@googlemail.com", "testrestapi").authorize.size.should > 100
  end

end
