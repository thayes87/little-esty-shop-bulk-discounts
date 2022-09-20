require 'httparty'
require 'json'

class GitHubService
  def self.request
    response = HTTParty.get('https://api.github.com/repos/Dominicod/little-esty-shop')
    json_response = JSON.parse(response.body,symbolize_names: true)
  end
end
