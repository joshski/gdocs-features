require 'file_feature_store'
require 'google_feature_store'
require 'google_docs_client'
require 'remote_features/dialogue'

module RemoteFeatures
  module Cli
    class Main
      def self.execute(args)
        new(args, $stdin, $stdout).execute
      end
      
      def initialize(args, input, output)
        if args.length != 2 || args[1] !~ /^(.+)\:(.+)@(.+)$/
          output.puts "Usage: remotefeatures <directory> <user:password@host>"
          Kernel.exit
          return 
        end
        @local_store = FileFeatureStore.new(args[0])
        m = /^(.+)\:(.+)@(.+)$/.match(args[1])
        @remote_store = GoogleFeatureStore.new(GoogleDocsClient.new(m[1], m[2]))
        @input, @output = input, output
      end
      
      def execute
        RemoteFeatures::Dialogue.new(@input, @output, @local_store, @remote_store).start
      end
    end
  end
end