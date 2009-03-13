require 'rake'
require 'spec/rake/spectask'
require 'cucumber/rake/task'

desc "Run all examples"
Spec::Rake::SpecTask.new('examples') do |t|
  t.spec_files = FileList['spec/**/*.rb']
end

desc "Run all features"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty" 
end

desc "Run pending features"
Cucumber::Rake::Task.new(:pending) do |t|
  t.cucumber_opts = "--format pretty -e features/** features-pending" 
end