require 'active_support/core_ext/string/inflections'

module Acclimate
  class Cli
    class Generate < Thor

      include Acclimate::CliHelper

      def self.banner( command, namespace=nil, subcommand=false )
        return "#{basename} generate help [SUBCOMMAND]" if command.name == 'help'
        "#{basename} #{command.usage}"
      end

      def self.project_name_option
        option :project_name, type: :string, desc: 'The name of the project acclimate is used within', default: Pathname.new(Dir.pwd).basename.to_s
      end

      desc "generate command", "Generate the classes to implement a new command"
      long_desc <<-LONGDESC
        Generate the classes to implement a new command.

        $ acclimate generate command some/namespaced/command
      LONGDESC
      project_name_option
      option :cli, type: :boolean, desc: 'When true, ensure/generate a corresponding CLI class', default: true
      option :cli_path, type: :string, desc: 'The rooth path for CLI classes', default: "lib/#{Pathname.new(Dir.pwd).basename}/cli"
      option :cli_base_class, type: :string, desc: 'The base class from which all CLIs inherit', default: "Thor"
      option :commands_path, type: :string, desc: 'The rooth path for command classes', default: "lib/#{Pathname.new(Dir.pwd).basename}/command"
      option :command_base_class, type: :string, desc: 'The base class from which all commands inherit', default: "#{Pathname.new(Dir.pwd).basename.to_s.camelcase}::Command::Base"
      def command( path )
        execute Acclimate::Commands::Generate::Command, path: path
      end

    end
  end
end
