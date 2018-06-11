class Users::LinksController < Users::ApplicationController
  before_filter :find_repository

  def create
    RepositoryUser.create(repository: @repository, user: @user, space: params[:space], handle: params[:handle])
    head :ok
  end

  def destroy
    RepositoryUser.delete(repository: @repository, user: @user, space: params[:space], handle: params[:handle])
    head :ok
  end

  private

  def find_repository
    @repository ||= Repository.find params[:id]
  end
end
