require_relative '../facades/github_facade'

class ApplicationController < ActionController::Base
  before_action :github

  def github
    data = GitHubFacade.github_info
    @github_name = data.name
    @github_logins = GitHubFacade.github_info("/collaborators", true)
  end
end
