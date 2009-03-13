require 'file_feature_store'
require 'tmpdir'
require 'fileutils'

Given /a local feature store$/ do
  @local_dir = File.join(Dir.tmpdir, 'feature_store')
  FileUtils.rm_rf @local_dir
  Dir.mkdir(@local_dir)
  @local_store = FileFeatureStore.new(@local_dir)
end

Given /^the local feature store contains:$/ do |table|
  table.hashes.each do | row |
    @local_store.create_feature(row['path'], row['version'], 'any old thing')
  end
end