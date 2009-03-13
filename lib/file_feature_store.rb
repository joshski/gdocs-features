require 'file_feature'

class FileFeatureStore
  def initialize(directory)
    @directory = directory
  end

  def features
    Dir.glob("#{@directory}/**/*.feature").map do | path |
      FileFeature.new(@directory, path[(@directory.length+1)..-1])
    end
  end
  
  def create_feature(path, version, contents)
    FileFeature.new(@directory, path).write(contents, version)
  end
end
