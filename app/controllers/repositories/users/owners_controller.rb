class Repositories::Users::OwnersController < Repositories::Users::ApplicationController
  def create
    Owner.create(repository: @repository, group: @repository.group, user: @user, recursive: true)
    head :ok
  end
end