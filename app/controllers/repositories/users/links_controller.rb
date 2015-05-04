class Repositories::Users::LinksController < Repositories::Users::ApplicationController
  def create
    RepositoryUser.create(repository: @repository, user: @user, space: params[:space], handle: params[:handle])
    head :ok
  end

  def destroy
    RepositoryUser.delete(repository: @repository, user: @user, space: params[:space], handle: params[:handle])
    head :ok
  end
end
