require "sinatra/base"

require "./app/lib/spotify"
require "./app/lib/artist_metadata"

class AugmentedSpotifyApi < Sinatra::Base
  before do
    content_type :json
  end

  get '/artists/:id' do
    artist_id = params[:id]
    artist_response = Spotify.new.find_artist(artist_id)
    artist_response.body
  end
end