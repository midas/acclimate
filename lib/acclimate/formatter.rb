require 'command_line_reporter'

module Acclimate
  class Formatter

    include CommandLineReporter

    def render
      raise NotImplementedError
    end

  protected

    def capture( &block )
      suppress_output
      block.call
      capture_output
    end

  end
end
