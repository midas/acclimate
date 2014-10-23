require "acclimate/version"
require 'rainbow'
require 'thor'

module Acclimate

  autoload :CliHelper,         'acclimate/cli_helper'
  autoload :Command,           'acclimate/command'
  autoload :Configuration,     'acclimate/configuration'
  autoload :ConfirmationError, 'acclimate/confirmation_error'
  autoload :Error,             'acclimate/error'
  autoload :Output,            'acclimate/output'

end
