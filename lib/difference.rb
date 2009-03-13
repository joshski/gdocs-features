class Difference
  attr_reader :local, :remote
  
  def initialize(local, remote, local_store)
    @local, @remote, @local_store = local, remote, local_store
  end
  
  def local_only?
    !@local.nil? && @remote.nil?
  end
  
  def remote_only?
    @local.nil? && !@remote.nil?
  end
  
  def change_description
    local_only? ? 'deleted' : remote_only? ? 'created' : 'updated'
  end
  
  def patch
    if remote_only?
      @local_store.create_feature(@remote.path, @remote.version, @remote.reformat)
    elsif !local_only?
      @local.patch_from(@remote)
    end
  end
  
  def path
    (@local || @remote).path
  end
end