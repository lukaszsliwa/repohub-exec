class Groups::Users::ApplicationController < Groups::ApplicationController
  before_filter :find_user

  def find_user
    @user = User.find params[:user_id]
  end
end
