require 'httparty'
require 'json'

class GitHubService
  def self.request(path, auth_required)
    if auth_required
      response = HTTParty.get("https://api.github.com/repos/Dominicod/little-esty-shop#{path}", headers: {authorization: "Bearer " + ENV['token']})
      JSON.parse(response.body, symbolize_names: true)
    else
      response = HTTParty.get("https://api.github.com/repos/Dominicod/little-esty-shop#{path}")
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
