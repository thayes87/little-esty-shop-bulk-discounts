require_relative '../poros/github'
require_relative '../services/github_service'

class GitHubFacade

  def self.github_info
    json_response = GitHubService.request

    response = json_response.map do |data|
      GitHub.new(data)
    end
  end
end
