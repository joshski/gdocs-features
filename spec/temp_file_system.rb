require 'tmpdir'
require 'fileutils'

class TempFileSystem
  attr_reader :root
  
  def initialize(hash)
    @root = File.join(Dir.tmpdir, Time.now.to_f.to_s)
    hash.each do |path,contents|
      full_path = File.expand_path(File.join(@root, path))
      FileUtils.mkdir_p(File.dirname(full_path))
      File.open(full_path, 'w') {|f| f.write(contents) }
    end
  end
  
  def destroy
    FileUtils.rm_rf @root
  end
end