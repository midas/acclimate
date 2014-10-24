require "acclimate/version"
require 'rainbow'
require 'thor'

module Acclimate

  autoload :Cli,               'acclimate/cli'
  autoload :CliHelper,         'acclimate/cli_helper'
  autoload :Command,           'acclimate/command'
  autoload :Commands,          'acclimate/commands'
  autoload :Configuration,     'acclimate/configuration'
  autoload :ConfirmationError, 'acclimate/confirmation_error'
  autoload :Error,             'acclimate/error'
  autoload :Output,            'acclimate/output'

end
