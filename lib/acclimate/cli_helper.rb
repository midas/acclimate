module Acclimate
  module CliHelper

    def self.included( base )
      base.class_eval do
        include Acclimate::Output

        no_commands do

          def execute( klass, additional_options={} )
            klass.new( options.merge( additional_options )).execute
          rescue Acclimate::Error => e
            handle_error( e ) unless e.handled?
            exit( e.exit_code || 1 )
          end

          def handle_error( e )
            say "Error: #{e.message}", :red
          end

        end
      end

      base.extend ClassMethods
    end

    module ClassMethods

      def handle_argument_error( command, error, _, __ )
        method = "handle_argument_error_for_#{command.name}"

        if respond_to?( method )
          send( method, command, error )
        else
          handle_argument_error_default( command, error )
        end
      end

      def handle_argument_error_default( command, error )
        $stdout.puts "Incorrect usage of command: #{command.name}"
        $stdout.puts "  #{error.message}", ''
        $stdout.puts "For correct usage:"
        $stdout.puts "  acclimate help #{command.name}"
      end

      def handle_no_command_error( name )
        $stdout.puts "Unrecognized command: #{name}"
      end

    end

  end
end
