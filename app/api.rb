require 'active_support'
require 'active_support/core_ext'
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
end