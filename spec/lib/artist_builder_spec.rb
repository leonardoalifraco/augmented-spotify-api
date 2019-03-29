require "./app/lib/artist_builder"

describe ArtistBuilder do
  subject { ArtistBuilder.new(artist_id) }

  let(:artist_id) { "0OdUWJ0sBjDrqHygGUXeCF" }
  let(:artist_response) { double("ArtistResponse") }

  describe "#fetch_artist" do
    before do
      spotify_double = double(Spotify)
      allow(Spotify).to receive(:new) { spotify_double }
      allow(spotify_double).to receive(:find_artist).with(artist_id) { artist_response }

      subject.fetch_artist
    end

    it "populates the subject artist" do
      expect(subject.artist).to eq(artist_response)
    end
  end

  describe "#add_metadata" do
    context "when the artist is not available" do
      before do
        subject.add_metadata
      end
      
      it "should do nothing" do
        expect(subject.artist).to be_nil
      end
    end

    context "when the artist is available" do
      let(:metadata_response) { { total_sales: 300 } }

      before do
        subject.instance_variable_set(:@artist, {})
        
        artist_metadata_double = double(ArtistMetadata)
        allow(ArtistMetadata).to receive(:new) { artist_metadata_double }
        allow(artist_metadata_double).to receive(:find_by_artist).with(artist_id) { metadata_response }

        subject.add_metadata
      end

      it "adds metadata to the artist" do
        expect(subject.artist[:metadata][:total_sales]).to eq(300)
      end
    end
  end
end