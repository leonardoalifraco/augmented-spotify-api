require 'aws-sdk-dynamodb'

class ArtistMetadata
  TABLE_KEY = 'artist_spotify_id'.freeze
  TABLE_NAME = 'artists'.freeze
  WHITELISTED_KEYS = [:total_sales].freeze
  DEFAULT_METADATA = {
    total_sales: nil
  }.freeze

  def find_by_artist(id)
    response = client.get_item({ 
      key: {
        TABLE_KEY => id 
      },
      table_name: TABLE_NAME,
      consistent_read: false
    })
    
    return DEFAULT_METADATA unless response.item
    item = response.item.to_h
      .except(TABLE_KEY)
      .with_indifferent_access
      .tap do |item|
        item[:total_sales] = item[:total_sales].to_i if item[:total_sales].present?
      end
  end

  def upsert(id, metadata)
    metadata = metadata.slice(*WHITELISTED_KEYS)
    
    expression_attribute_names = metadata.keys.map { |k| ["##{k}", k.to_s] }.to_h
    expression_attribute_values = metadata.map { |k, v| [":#{k}", v] }.to_h
    update_expression = "SET #{metadata.keys.map{ |k| "##{k} = :#{k}" }.join(', ') }"

    response = client.update_item({
      expression_attribute_names: expression_attribute_names,
      expression_attribute_values: expression_attribute_values,
      key: {
        TABLE_KEY => id
      },
      table_name: TABLE_NAME,
      update_expression: update_expression
    })
  end

  private
  def client
    @dynamodb_client ||= Aws::DynamoDB::Client.new(region: ENV['AWS_REGION'])
  end
end