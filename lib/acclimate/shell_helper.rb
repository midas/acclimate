module Acclimate
  module ShellHelper

    def self.included( base )
      base.send( :include, CommandLineReporter )
      base.send( :include, Acclimate::Output )
    end

  end
end
