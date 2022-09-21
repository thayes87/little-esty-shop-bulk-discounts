require 'httparty'
require 'json'

class GithubService
  def self.request(path, auth_required)
    if auth_required
      return [{login: 'Dominicod'}, {login: 'rebeckahendricks'}, {login: 'lcole37'}, {login: 'thayes87'}] if Rails.env == 'test'
      response = HTTParty.get("https://api.github.com/repos/Dominicod/little-esty-shop#{path}", headers: {authorization: "Bearer " + ENV['token']})
      JSON.parse(response.body, symbolize_names: true)
    else
      return {name: 'little-esty-shop'} if Rails.env == 'test'
      response = HTTParty.get("https://api.github.com/repos/Dominicod/little-esty-shop#{path}")
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
