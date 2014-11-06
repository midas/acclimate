require 'pathname'

module Acclimate
  class Env

    def initialize( sources )
      @sources = sources.map { |s| Pathname.new( s ) }
    end

    def load
      sources.each do |source|
        source_env_from( source.expand_path )
      end
    end

  protected

    attr_reader :sources

    def bash_env( cmd=nil )
      env = `#{cmd + ';' if cmd} printenv`
      env.split( /\n/ ).map { |l| l.split(/=/) }
    end

    def bash_source( file )
      Hash[bash_env(". #{File.realpath file}") - bash_env]
    end

    def source_env_from( file )
      bash_source( file ).each { |k,v| ENV[k] = v }
    end

  end
end
