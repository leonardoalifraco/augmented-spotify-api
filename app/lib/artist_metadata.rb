require 'aws-sdk-dynamodb'

class ArtistMetadata
  TABLE_KEY = 'artist_spotify_id'
  TABLE_NAME = 'artists'
  DEFAULT_METADATA = {
    total_sales: nil
  }

  def find_by_artist(id)
    response = client.get_item({ 
      key: {
        TABLE_KEY => id 
      },
      table_name: TABLE_NAME,
      consistent_read: false
    })
    
    return DEFAULT_METADATA unless response.item
    response.item.to_h.except(TABLE_KEY).with_indifferent_access
  end

  private
  def client
    @dynamodb_client ||= Aws::DynamoDB::Client.new(region: ENV['AWS_REGION'])
  end
end