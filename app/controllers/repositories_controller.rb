class RepositoriesController < ApplicationController
  def show
    @repository = Repository.find params[:id]
    render json: @repository.to_json
  end

  def destroy
    @repository = Repository.find params[:id]
    if @repository.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
