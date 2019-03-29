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
    let(:total_sales) { 300 }
    let(:metadata) { 
      { 
        metadata: { 
          total_sales: total_sales
        }
      }
    }

    before do
      post "/artists/#{artist_id}/metadata", metadata.to_json
    end

    context "with valid metadata" do
      it "should respond no content" do
        expect(last_response).to be_no_content
      end
    end

    context "with invalid metadata" do
      let(:total_sales) { "invalid total sales" }

      it "should respond bad request" do
        expect(last_response).to be_bad_request
      end

      it "should indicate what the error was on the response body" do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body).to have_key("errors")
        expect(parsed_body["errors"]).to match_array([
          'total_sales must be numeric'
        ])
      end
    end
  end
end