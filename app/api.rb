require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'sinatra/base'

require './app/lib/artist_builder'

class AugmentedSpotifyApi < Sinatra::Base
  before do
    content_type :json
  end

  get '/artists/:id' do
    artist_id = params[:id]
    
    builder = ArtistBuilder.new(artist_id)
    builder.fetch_artist
    builder.add_sales_metadata
    
    artist = builder.artist
    
    status 404 and return unless artist
    artist.to_json
  end

  post '/artists/:id/metadata' do
    artist_id = params[:id]
    metadata = JSON.parse(request.body.read).with_indifferent_access
    ArtistMetadata.new.upsert(artist_id, metadata[:sales_metadata])
    status 204
  end
end