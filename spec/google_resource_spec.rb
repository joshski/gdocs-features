require File.dirname(__FILE__) + '/spec_helper'

require 'google_resource'

describe GoogleResource do
  
  it "should include the authorization header on get" do
    auth = mock("auth", :header => "xxx")
    RestClient.should_receive(:get).with("url", hash_including("Authorization" => "xxx"))
    GoogleResource.new(auth, "url").get
  end

  it "should include additional headers on get" do
    auth = mock("auth", :header => "xxx")
    RestClient.should_receive(:get).with("url", hash_including("another" => "zzz"))
    GoogleResource.new(auth, "url").get("another" => "zzz")
  end

  it "should include constructor headers on get" do
    auth = mock("auth", :header => "xxx")
    RestClient.should_receive(:get).with("url", hash_including("another" => "zzz"))
    GoogleResource.new(auth, "url", {"another" => "zzz"}).get
  end

end
