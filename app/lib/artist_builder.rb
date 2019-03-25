require './app/lib/spotify'
require './app/lib/artist_metadata'

class ArtistBuilder
  attr_reader :artist

  def initialize(artist_id)
    @artist_id = artist_id
  end

  def fetch_artist
    @artist = Spotify.new.find_artist(@artist_id)
  end

  def add_sales_metadata
    return unless @artist

    metadata = ArtistMetadata.new.find_by_artist(@artist_id)
    metadata[:total_sales] = metadata[:total_sales].to_i
    @artist.merge!(metadata)
  end
end