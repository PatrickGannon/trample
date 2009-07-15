module Trample
  class Runner
    include Logging

    attr_reader :config, :threads

    def initialize(config)
      @config  = config
      @threads = []
    end

    def trample
      logger.info "Starting trample..."
      config.concurrency.times do
        thread = Thread.new(@config) do |c|
          Session.new(c).trample
        end
        threads << thread
      end
      begin 
        threads.each { |t| t.join }
      rescue RestClient::RequestTimeout => e
        logger.info "Request timed out #{e}"
      end
      logger.info "Trample completed..."
      
      stats = Statistics.new(log_file)
      stats.produce_statistics
    end
  end
end

