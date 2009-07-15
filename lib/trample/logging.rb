module Trample
  module Logging
    attr_accessor :log_file
    
    def logger
      init_logger if Log4r::Logger['main'].nil?
      logger = Log4r::Logger['main']
    end

    protected
    def init_logger
      logger = Log4r::Logger.new('main')
      @log_file = 'trample.log'
      file_outputter = Log4r::FileOutputter.new('main', :filename => @log_file, :trunc => true)
      file_outputter.formatter = Log4r::PatternFormatter.new(:pattern => "%m")
      logger.outputters = [Log4r::Outputter.stdout, file_outputter]
    end
  end
end
