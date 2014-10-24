require 'thor'

module Acclimate
  class Cli < Thor

    autoload :Generate, 'acclimate/cli/generate'

    include Acclimate::CliHelper

    desc 'generate SUBCOMMAND', "Generate CLI classes"
    subcommand "generate", Acclimate::Cli::Generate

  end
end
