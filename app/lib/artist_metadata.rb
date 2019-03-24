require 'aws-sdk-dynamodb'

class ArtistMetadata
  def find_by_artist(id)
    client.get_item({ 
      key: {
        'ArtistSpotifyId' => id 
      },
      table_name: 'artists',
      consistent_read: false
    })
  end

  private
  def client
    @dynamodb_client ||= Aws::DynamoDB::Client.new(region: ENV['AWS_REGION'])
  end
end