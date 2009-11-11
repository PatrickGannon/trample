gem 'sevenwire-rest-client'
require 'log4r'
require 'rest_client'
require 'scruffy'
require 'nokogiri'
require File.dirname(__FILE__) + "/trample/scruffy_extensions/box_plot"
require File.dirname(__FILE__) + "/trample/scruffy_extensions/data_markers"
require File.dirname(__FILE__) + "/trample/scruffy_extensions/value_markers"
require File.dirname(__FILE__) + "/trample/scruffy_extensions/simple_line"

module Trample
  autoload :Configuration, File.dirname(__FILE__) + "/trample/configuration"
  autoload :Page, File.dirname(__FILE__) + "/trample/page"
  autoload :Session, File.dirname(__FILE__) + "/trample/session"
  autoload :Runner, File.dirname(__FILE__) + "/trample/runner"
  autoload :Cli, File.dirname(__FILE__) + "/trample/cli"
  autoload :Logging, File.dirname(__FILE__) + "/trample/logging"
  autoload :Timer, File.dirname(__FILE__) + "/trample/timer"
  autoload :Statistics, File.dirname(__FILE__) + "/trample/statistics"
  TEMPLATE_ROOT = File.join(File.dirname(__FILE__), '..', 'templates')
  
  class << self
    attr_reader :current_configuration

    def configure(&block)
      @current_configuration = Configuration.new(&block)
    end
  end
end

