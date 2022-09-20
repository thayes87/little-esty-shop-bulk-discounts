require 'httparty'
require 'json'

class GitHubService
  def self.request
    response = HTTParty.get('https://ghibliapi.herokuapp.com/films/')
    json_response = JSON.parse(response.body,symbolize_names: true)
  end
end
