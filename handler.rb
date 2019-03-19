require 'json'
require 'httparty'

def hello(event:, context:)
  response = HTTParty.get('http://worldclockapi.com/api/json/utc/now')
  { statusCode: response.code, body: JSON.parse(response.body) }
end
