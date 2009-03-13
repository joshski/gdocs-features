require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/temp_file_system'

require 'file_feature_store'

describe FileFeatureStore do

  before do
    @fs = TempFileSystem.new(
      'my/stuff/banana.feature' => 'OK'
    )
  end
  
  after do
    @fs.destroy
  end  

  it "should find files with .feature extension" do
    store = FileFeatureStore.new("/some/dir")
    Dir.should_receive(:glob).with("/some/dir/**/*.feature").and_return([])
    store.features
  end
  
  describe "with a physical file store" do
    
    it "should find features" do
      store = FileFeatureStore.new(@fs.root)
      store.features.first.title.should == "banana"
    end
    
  end

end
