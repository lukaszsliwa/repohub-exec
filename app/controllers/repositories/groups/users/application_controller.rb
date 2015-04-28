class Repositories::Groups::Users::ApplicationController < Repositories::Groups::ApplicationController
  before_filter :find_user

  def find_user
    @user = User.find params[:user_id]
  end
end
