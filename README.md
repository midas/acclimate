# Acclimate

A CLI building toolkit.  Pronounced A CLI Mate.


## Installation

Add this line to your application's Gemfile:

    gem 'acclimate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acclimate


## Usage

Acclimate provides a toolkit to aid in the boilerplate pieces of a CLI project including: configuration, commands, 
helpers for the CLI class(es), error handling and some output helpers.  Acclimate assumes the usage of 
[Thor](http://whatisthor.com/) for creating the CLI portion of your CLI project.  Please refer to Thor's documentation
for further help.

### CliHelper

Acclimate's CliHelper module provides convenience methods as well as some sane defaults for [Thor](http://whatisthor.com/).

#### The #execute Method

The execute method provides a common API to direct your CLI commands to actual command class instances to do the work.

    module AwesomeCli
      class Cli < Thor
        include Acclimate::CliHelper

        desc "some-command", "Does something useful"
        option :do_it_good, type: :boolean
        def some_command( filepath )
          execute AwesomeCli::Command::SomeCommand, filepath: filepath
        end
      end
    end

The call to `#execute` instantiates the command class, and merges the filepath argument into the options arguments, passing
it into the command class' initializer.


### Configuration

Acclimate's configuration class provides a base from which to build a custom configuration class in your
CLI project.  The simplest implementation of a configuration class for your project is to inherit from 
`Acclimate::Configuration` and do nothing else.

    module AwesomeCli
      class Configuration < Acclimate::Configuration
      end
    end

Now you can use the configuration class simply by passing a hash of values into it.

    conf = AwesomeCli::Configuration.new( env: 'development', filepath: 'some/file/path' )

    conf[:env]               #=> 'development'
    conf['env']              #=> 'development'
    conf.env                 #=> 'development'
    conf.slice( :env )       #=> { :env => 'development }
    conf.slice( :env ).class #=> AwesomeCli::Configuration

Pretty much any method that works on a standard `Hash` will work on the configuration.  This magic is a result
of `Acclimate::Configuration` inheriting from [Hashie::Mash](https://github.com/intridea/hashie#mash).

In addition, any commands (see the commands section below) that inherit from `Acclimate::Command` accept the
command line options in their initializer and expose a `#config` method that wraps the options in a configuration
object for you.

### Commands

Acclimate's command class provides a base from which to build the commands for your CLI.  Whn building an Acclimate
CLI, we use commands to encapsulate the actual behavior of each CLI defined command or sub-command.  This serves multiple 
purposes.  First, it keeps the command logic out of the CLI class(es), which is basically the view or GUI of a CLI project.
Second, having the actual logic encapsulated in a command means including our CLI gem into another project and borrowing 
the behavior is possible through direct utilization of the command class(es), without interacting with the CLI classes.

Building a command class is as simple as inheriting from `Acclimate::Command` and implementing an `#execute` method.

    module AwesomeCli
      class SomeCommand < Acclimate::Command
        def execute
          # do something useful ...
        end
      end
    end

Due to the fact that your commands will certainly have some additional common behavior that Acclimate does not provide,
it is a good idea to have a base class for your commands.  For instance, in order to use your custom configuration class 
as opposed to an instance of `Acclimate::Configuration`, you must override the `#config_klass` method in your command(s). 
You command base class is the ideal place to do so.

    module AwesomeCli
      class CommandBase < Acclimate::Command
      protected
        def a_helper
          # do something helpful
        end

        def config_klass
          AwesomeCli::Configuration
        end
      end

      class SomeCommand < CommandBase
        def execute
          # do something useful ...
        end
      end
    end

### Output

Acclimate's output module can be included in any class in your CLI and is already included in any class that inherits from
`Acclimate::Command` or includes `Acclimate::CliHelper`.  In addition to it own [output helpers](https://github.com/midas/acclimate/blob/master/lib/acclimate/output.rb), 
the module also include [Thor's shell module](http://rdoc.info/github/wycats/thor/Thor/Shell/Basic).

#### The #confirm Method

Acclimate's `#confirm` method is the accepted strategy for outputting command status throughout the execution of the 
command.  The `#confirm` method outputs a statement, executes a provided block, then outputs either OK or ERROR depending 
on the results of the block.

    module AwesomeCli
      module SomeCommand < CommandBase
        def execute
          confirm "Doing something useful" do
            # something useful here
          end

          confirm "Doing something helpful" do
            # something helpful here
          end
        end
      end
    end

Executing the previous command

    command = AwesomeCli::SomeCommand.new
    command.execute

Results in the following output

    Doing something useful ... OK
    Doing something helpful ... OK


## Error Handling

Acclimate can handle known error conditions gracefully for you.  In the cases wher eyou would like to output a useful
error message but not overwhelm your user with a Ruby backtrace, simply raise the `Acclimate::Error`.

    raise Acclimate::error, 'External service unavailable, please try the command again later'

### Errors and the #confirm Method

If an error is encountered within the block that should be gracefully handled by Acclimate as opposed to an ugly Ruby
stacktrace, you may raise Acclimate::Error.

    module AwesomeCli
      module SomeCommand < CommandBase
        def execute
          confirm "Doing something useful" do
            raise Acclimate::Error, 'A known error description'
          end
        end
      end
    end

Executing the previous command

    command = AwesomeCli::SomeCommand.new
    command.execute

Results in the following output

    Doing something useful ... ERROR
    Error: A known error condition

By default, the exit code for an error is 1.  This can be overridden when raising an error.

    raise Acclimate::Error.new( 'A known error description', exit_code: 35 )

In some cases it is not enough to raise an `Acclimate::Error` and let the graceful error handling ensue.  You may need 
to clean something up or want to output additional error details.  It is this case the `Acclimate::ConfirmationError` is
for.
 
Let's assume your command is parsing a text file and wants to output which lines were unparseable along with an error 
message.

    module AwesomeCli
      module ParseTextFile < CommandBase
        def execute
          confirm "Parsing text file" do
            parse_file
            raise_if_in_error_lines!
          end
        end

      protected

        def raise_if_in_error_lines!
          raise Acclimate::ConfirmationError.new( 'Unparseable lines were encountered', exit_code: 12, 
                                                                                        finish_proc: report_in_error_lines )
        end

        def report_in_error_lines
          -> {
            in_error_lines.each do |line|
              say_stderr( "  #{line}" )
            end
          }
        end

        def parse_file
          File.readlines( config.filepath ).each do |line|
            begin
              parse_line( line )
            rescue
              in_error_lines << line
            end
          end
        end

        def parse_line( line )
          # some parsing logic ...
        end

        def in_error_lines
          @in_error_lines ||= []
        end

      end
    end

Executing the previous command

    command = AwesomeCli::ParseTextFile.new
    command.execute

Results in the following output

    Parsing text file ... ERROR
    Unparseable lines were encountered
      1 something unparseable
      7 something else unparseable

