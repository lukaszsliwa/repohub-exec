class Repositories::Groups::Users::OwnersController < Repositories::Groups::Users::ApplicationController
  def create
    Owner.create(repository: @repository, group: @group, user: @user, recursive: true)
    head :ok
  end
end