require_relative '../poros/github_name'
require_relative '../poros/github_collaborator'
require_relative '../services/github_service'

class GitHubFacade
  def self.github_info(path = "", auth_required = false)
    json_response = GitHubService.request(path, auth_required)
    if path == ""
      GitHubName.new(json_response)
    elsif path == "/collaborators"
      json_response.map do | collaborator |
        GitHubCollaborator.new(collaborator)
      end
    end
  end
end