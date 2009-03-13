require 'feature_diff'
require 'remote_features/cli/main'

When /^I run the program$/ do
  RemoteFeatures::Cli::Main.execute([@local_dir, "restapitest:testrestapi@docs.google.com"])
end

Then /^I should see the following changes:$/ do | table |
  table.hashes.each do | row |
    difference = @diff[row['path']]
    raise "#{row['path']} not present -- #{@diff.inspect}" if difference.nil?
    difference.change_description.should == row['change']
  end
  @diff.differences.each do | path, difference |
    if table.hashes.find { |h| h['path'] == path }.nil?
      raise "Unexpected change to #{path} (#{difference.change_description})"
    end
  end
end