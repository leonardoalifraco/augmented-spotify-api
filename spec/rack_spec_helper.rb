require 'rack/test'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app/api.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() AugmentedSpotifyApi end
end

RSpec.configure do |config|
  config.include RSpecMixin
end

