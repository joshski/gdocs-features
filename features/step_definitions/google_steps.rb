require 'google_feature_store'
require 'google_docs_client'

Given /a google docs feature store$/ do
  @client = GoogleDocsClient.new("restapitest@googlemail.com", "testrestapi")
  @remote_store = GoogleFeatureStore.new(@client)
end

Given /^the google docs feature store contains:$/ do | table |
  features = @remote_store.features
  features.size.should == table.hashes.size
  table.hashes.each do | row |
    matches = features.find_all { |f| f.path == row['path'] }
    matches.size.should == 1
    if matches.first.version != row['version']
      raise "expected '#{row['path']}' to have version '#{row['version']}', got '#{matches.first.version}'" 
    end
  end
end