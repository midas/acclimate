require 'pathname'

module Acclimate
  class Command

    include Acclimate::ShellHelper

    def initialize( options )
      @options = options
    end

    def execute
      raise NotImplementedError, "You must implement #{self.class.name}#execute"
    end

  protected

    attr_reader :options

    def base_path
      Pathname.new( Dir.pwd )
    end

    def config
      @config = config_klass.load( options )
    end

    def config_filepath
      config_klass.config_filepath
    end

    def config_klass
      Acclimate::Configuration
    end

  end
end
