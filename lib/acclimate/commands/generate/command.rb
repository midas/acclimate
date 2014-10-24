require 'active_support/core_ext/string/inflections'
require 'thor'

module Acclimate
  module Commands
    module Generate
      class Command < Acclimate::Commands::Base

        def execute
          generate_command
        end

      protected

        def generate_command
          cli_path.dirname.mkpath
          command_path.dirname.mkpath

          if generate_cli?
            confirm "Ensuring cli #{cli_filepath}" do
              generate_cli_class_file
            end
          end

          confirm "Generating command #{command_filepath}" do
            generate_class_file
          end
        end

        def generate_cli_class_file
          return if cli_filepath.exist?

          File.open( cli_filepath, 'w' ) do |file|
            file.write cli_content
          end
        end

        def generate_class_file
          if command_filepath.exist?
            raise Acclimate::Error, "Command already exists"
          end

          File.open( command_filepath, 'w' ) do |file|
            file.write command_content
          end
        end

        def generate_cli?
          config.cli
        end

        def cli_content
          content = []
          closing = []
          cli_module_path.each_with_index do |m, idx|
            content << "#{' ' * idx * 2}module #{m}"
            closing << "#{' ' * idx * 2}end"
          end
          content <<  "#{' ' * content.size * 2}class #{cli_class_name} < #{config.cli_base_class}"
          closing <<  "#{' ' * (content.size - 1) * 2}end"
          content += closing.reverse
          content.join( "\n" )
        end

        def command_content
          content = []
          closing = []
          command_module_path.each_with_index do |m, idx|
            content << "#{' ' * idx * 2}module #{m}"
            closing << "#{' ' * idx * 2}end"
          end
          content <<  "#{' ' * content.size * 2}class #{class_name} < #{config.command_base_class}"
          closing <<  "#{' ' * (content.size - 1) * 2}end"
          content += closing.reverse
          content.join( "\n" )
        end

        def cli_class_name
          path = config.path.split( '/' )
          path[path.size-2].camelcase
        end

        def class_name
          config.path.split( '/' ).last.camelcase
        end

        def cli_module_path
          [
            config.cli_path.gsub( /lib\//, '' ).split( '/' ),
            config.path.split( '/' )
          ].flatten[0...-2].
            map( &:camelcase )
        end

        def command_module_path
          [
            config.commands_path.gsub( /lib\//, '' ).split( '/' ),
            config.path.split( '/' )
          ].flatten[0...-1].
            map( &:camelcase )
        end

        def cli_filepath
          clis_path + (File.join( config.path.split( '/' )[0...-1] ) + '.rb')
        end

        def command_filepath
          commands_path + "#{config.path}.rb"
        end

        def cli_path
          cli_filepath.dirname
        end

        def command_path
          commands_path + config.path
        end

        def clis_path
          @clis_path ||= Pathname.new( config.cli_path )
        end

        def commands_path
          @commands_path ||= Pathname.new( config.commands_path )
        end

      end
    end
  end
end
