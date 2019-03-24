require "httparty"

class Spotify
  include HTTParty
  base_uri 'https://api.spotify.com/v1/'
  default_timeout 2

  def find_artist(id)
    options = { headers: headers }
    self.class.get("/artists/#{id}", options)
  end

  private
  def headers
    { 'Authorization' => "#{token['token_type']} #{token['access_token']}" }
  end

  def token
    return @@token if valid_token?
    @@token = begin
      new_token = request_token
      new_token['expires_at'] = Time.now + new_token['expires_in']
      new_token
    end
  end
  
  def valid_token?
    defined?(@@token) && (Time.now - 30) < @@token['expires_at']
  end

  def request_token
    client_id = ENV['SPOTIFY_CLIENT_ID']
    client_secret = ENV['SPOTIFY_CLIENT_SECRET']
    client_id_secret = Base64.strict_encode64("#{client_id}:#{client_secret}")
    headers = { 'Authorization' => "Basic #{client_id_secret}" }
    
    body = { 'grant_type' => 'client_credentials' }
    
    response = HTTParty.post(
      'https://accounts.spotify.com/api/token',
      headers: headers,
      body: body
    )

    if response.ok?
      @@token = response.parsed_response
    end
  end
end