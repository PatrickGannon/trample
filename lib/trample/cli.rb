require 'thor'

module Trample
  class Cli < Thor
    desc "start path/to/config/file", "Start trampling"
    def start(config)
      load(config)
      Runner.new(Trample.current_configuration).trample
    end
    
    desc "statistics path/to/log/file", "Build statistics off of existing trample log file"
    def statistics(logfile)
      Statistics.new(logfile).produce_statistics
    end
  end
end
