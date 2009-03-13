require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/temp_file_system'

describe TempFileSystem do
  before do
    @fs = TempFileSystem.new(
      'fish/happy/salmon.txt' => 'Hi there',
      'fish/sad/trout' => 'Goodbye'
    )
  end
  
  after do
    @fs.destroy
  end
  
  it "should create text files as specified in a hash of path => content" do
    File.readlines(File.join(@fs.root, 'fish/happy/salmon.txt')).should == ['Hi there']
    File.readlines(File.join(@fs.root, 'fish/sad/trout')).should == ['Goodbye']
  end
  
  it "should destroy everything under the root" do
    File.exist?(File.join(@fs.root, 'fish/happy/salmon.txt')).should == true
    File.exist?(File.join(@fs.root, 'fish/sad/trout')).should == true
    @fs.destroy
    File.exist?(File.join(@fs.root, 'fish/happy/salmon.txt')).should == false
    File.exist?(File.join(@fs.root, 'fish/sad/trout')).should == false
  end
end