require 'difference'

class FeatureDiff
  attr_reader :differences
  
  def initialize(local_store, remote_store)
    @local_store, @remote_store = local_store, remote_store
    @differences = {}    
    remote_features = Hash[*remote_store.features.map { | f | [f.path, f] }.flatten]
    local_features = Hash[*local_store.features.map { | f | [f.path, f] }.flatten]
    add_differences(local_features, remote_features)
  end

  def [](path)
    @differences[path]
  end

  def patch(indices=nil)
    @differences.values.each_with_index do | difference, index |
      if indices.nil? || indices.include?(index + 1)
        difference.patch
      end
    end
  end
  
  private
  
  def add(local, remote)
    @differences[(local || remote).path] = Difference.new(local, remote, @local_store)
  end
  
  def add_differences(local_features, remote_features)
    remote_features.each do | path, remote |
      local = local_features[path]
      if local
        add(local, remote) unless local.version == remote.version
      else
        add(nil, remote)
      end
      local_features.delete(path)
    end
    local_features.each do | path, local |
      add(local, nil)
    end
  end 
end
