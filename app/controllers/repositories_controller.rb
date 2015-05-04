class RepositoriesController < ApplicationController
  def show
    @repository = Repository.find params[:id]
    render json: @repository.to_json
  end

  def create
    @group = Group.find params[:db_id]
    if @group.save
      head :ok
    else
      render json: {errors: @group.errors.full_messages}.to_json, status: :unprocessable_entity
    end
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
