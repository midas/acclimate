require 'hashie'

module Acclimate
  class Configuration < Hashie::Mash

    def initialize( options={} )
      super( options )
    end

    def slice( *keys )
      klass.new( select { |k,v| keys.map( &:to_s ).include?( k ) } )
    end

  protected

    def klass
      self.class
    end

  end
end
