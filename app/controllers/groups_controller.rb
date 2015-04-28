class GroupsController < ApplicationController
  def show
    @group = Group.find params[:id]

    render json: @group.as_json
  end

  def create
    @group = Group.new(params.slice(:id))
    if @group.save
      head :ok
    else
      render json: {errors: @group.errors.full_messages}.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    @group = Group.find params[:id]
    if @group.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
