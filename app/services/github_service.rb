require 'httparty'
require 'json'

class GitHubService
  def self.request(path, auth_required = false)
    if auth_required
      response = HTTParty.get("https://api.github.com/repos/Dominicod/little-esty-shop#{path}", headers: {authorization: "Bearer " + ENV['token']})
      json_response = JSON.parse(response.body, symbolize_names: true)
    else
      response = HTTParty.get("https://api.github.com/repos/Dominicod/little-esty-shop#{path}")
      json_response = JSON.parse(response.body, symbolize_names: true)
    end
  end
end
