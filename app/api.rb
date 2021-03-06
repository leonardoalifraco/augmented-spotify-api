require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'sinatra/base'

require './app/lib/artist_builder'

class AugmentedSpotifyApi < Sinatra::Base
  set :show_exceptions, :after_handler

  before do
    content_type :json
  end

  get '/artists/:id' do
    artist_id = params[:id]
    
    builder = ArtistBuilder.new(artist_id)
    builder.fetch_artist
    builder.add_metadata
    
    artist = builder.artist
    
    status 404 and return unless artist
    artist.to_json
  end

  post '/artists/:id/metadata' do
    artist_id = params[:id]
    metadata = JSON.parse(request.body.read).with_indifferent_access
    ArtistMetadata.new.upsert(artist_id, metadata[:metadata])
    status 204
  end

  error ValidationError do
    status 400
    { errors: env['sinatra.error'].errors }.to_json
  end
end