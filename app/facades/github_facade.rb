require_relative '../poros/github'
require_relative '../services/github_service'

class GitHubFacade
  def self.github_info
    json_response = GitHubService.request

    GitHub.new(json_response)
  end
end
