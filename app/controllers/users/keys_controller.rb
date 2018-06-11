class Users::KeysController < Users::ApplicationController
  def create
    @user.update_keys(params[:keys])
    head :ok
  end
end
