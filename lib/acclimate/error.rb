module Acclimate
  class Error < StandardError

    def initialize( message, options={} )
      @options = options

      super( message )
    end

    def exit_code
      options[:exit_code] || 1
    end

    def handled?
      options[:handled] || false
    end

  protected

    attr_reader :options

  end
end
