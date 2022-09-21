class ApplicationController < ActionController::Base
  before_action :github

  def github
    data = GithubFacade.github_info
    @github_name = data.name
    @github_logins = GithubFacade.github_info("/collaborators", true)
  end
end
