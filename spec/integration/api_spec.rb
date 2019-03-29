require "rack_spec_helper"

describe "Augmented Spotify Api" do
  describe "GET /artists/:id" do
    before do
      get "/artists/#{artist_id}"
    end

    context "with a valid artist id" do
      let(:artist_id) { "0OdUWJ0sBjDrqHygGUXeCF" }

      it "should respond ok" do
        expect(last_response).to be_ok
      end

      it "should include the artist metadata" do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body).to have_key("metadata")
      end
    end

    context "with an invalid artist id" do
      let(:artist_id) { "invalid-artist-id" }

      it "should respond not found" do
        expect(last_response).to be_not_found
      end
    end
  end

  describe "POST /artists/:id/metadata" do
    let(:artist_id) { "0OdUWJ0sBjDrqHygGUXeCF" }
    let(:metadata) { 
      { 
        metadata: { 
          total_sales: 300
        }
      }
    }

    context "with valid metadata" do
      before do
        post "/artists/#{artist_id}/metadata", metadata.to_json
      end

      it "should respond no content" do
        expect(last_response).to be_no_content
      end
    end
  end
end