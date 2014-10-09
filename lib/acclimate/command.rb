require 'pathname'

module Acclimate
  class Command

    include Acclimate::Output

    def initialize( options )
      @options = options
    end

    def execute
      raise NotImplementedError, "You must implement #{self.class.name}#execute"
    end

  protected

    attr_reader :options

    def config
      @config = config_klass.new( options )
    end

    def base_path
      Pathname.new( Dir.pwd )
    end

    def config_klass
      Acclimate::Configuration
    end

  end
end
