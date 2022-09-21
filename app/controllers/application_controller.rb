class ApplicationController < ActionController::Base
  # before_action :github

  def github
    @github_name = GitHubFacade.github_info.name
    @github_logins = GitHubFacade.github_info("/collaborators", true)
  end
end
