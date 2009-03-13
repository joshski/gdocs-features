require 'feature_diff'

module RemoteFeatures
  class Dialogue
    def initialize(input, output, local_store, remote_store)
      @input, @output, @local_store, @remote_store = input, output, local_store, remote_store
    end
    
    def start
      diff = FeatureDiff.new(@local_store, @remote_store)
      differences = diff.differences
      if differences.empty?
        @output.puts "No changes. Local store is up-to-date."
        Kernel.exit
      end
      i = 0
      lines = diff.differences.values.map do |d|
        "#{(i += 1)}) #{d.change_description} - #{d.path}"
      end
      @output.puts lines.join("\n")
      @output.puts "Enter changes to apply, 'all' to apply all, or blank to exit"
      diff.patch(@input.gets.strip.split(/\s+/).map { |e| e.to_i })
    end
  end
end