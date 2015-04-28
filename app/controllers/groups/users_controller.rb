class Groups::UsersController < ApplicationController
  before_filter :find_user

  def show
    render json: @user.to_json
  end

  def find_user
    @user = User.find params[:id]
  end
end
