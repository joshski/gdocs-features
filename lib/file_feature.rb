require 'feature'
require 'fileutils'

class FileFeature < Feature
  attr_reader :path
  
  def initialize(dir, path)
    @dir, @path = dir, path
    @physical_path = File.join(dir, path)
  end

  def title
    File.basename(@path, ".feature")
  end

  def version
    match = /#\s*version\s*:\s*(.+)/i.match(lines.first)
    match && match[1].strip
  end

  def body
    version ? lines[1..-1] : lines
  end

  def lines
    File.readlines(@physical_path).map { |line| line.strip }.reject { |l| l == "" }
  end
  
  def write(contents, version)
    FileUtils.mkdir_p(File.dirname(@physical_path))
    File.open(@physical_path, 'w') { |f| f.write("#version: #{version}\n#{contents}") }
  end
  
  def patch_from(other)
    write(other.reformat, other.version)
  end
end
