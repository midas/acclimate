module Acclimate
  class ConfirmationError < StandardError

    def initialize( message, options={} )
      @options = options
      super( message )
    end

    def exit_code
      options[:exit_code] || 1
    end

    def finish
      return unless finish_proc
      finish_proc.call
    end

  protected

    attr_reader :options

    def finish_proc
      options[:finish_proc]
    end

  end
end
