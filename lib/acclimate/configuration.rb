require 'hashie'
require 'pathname'
require 'yaml'

module Acclimate
  class Configuration < Hashie::Mash

    def self.load( options={} )
      new( file_options.merge( options ))
    end

    def self.config_filepath
    end

    def config_filepath
      Pathname.new( self.class.config_filepath )
    end

    def slice( *keys )
      klass.new( select { |k,v| keys.map( &:to_s ).include?( k ) } )
    end

    def for_env
      return Hashie::Mash.new({}) unless env
      self[env]
    end

  protected

    def self.file_options
      return {} unless config_filepath

      File.exists?( config_filepath ) ?
        load_file_options :
        {}
    end

    def self.load_file_options
      YAML::load( File.read( config_filepath ))
    end

    def klass
      self.class
    end

  end
end
