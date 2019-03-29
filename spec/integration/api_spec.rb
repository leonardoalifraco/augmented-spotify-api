require "spec_helper.rb"

describe "Augmented Spotify Api" do
  describe "#/artists/:id" do
    before do
      get "/artists/#{artist_id}"
    end

    context "with a valid artist id" do
      let(:artist_id) { "0OdUWJ0sBjDrqHygGUXeCF" }

      it "should retrieve an artist by id" do
        expect(last_response).to be_ok
      end

      it "should include the artist metadata" do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body).to have_key("metadata")
      end
    end

    context "with an invalid artist id" do
      let(:artist_id) { "invalid-artist-id" }

      it "should return a 404" do
        expect(last_response).to be_not_found
      end
    end
  end
end