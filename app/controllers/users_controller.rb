class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    render json: @user.to_json
  end

  def create
    @user = User.new(id: params[:login])
    if @user.save
      head :ok
    else
      render json: {errors: @user.errors.full_messages}.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find params[:id]
    if @user.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
