class Groups::Users::LinksController < Groups::Users::ApplicationController
  def create
    UserGroup.create(group: @group, user: @user)
    head :ok
  end

  def destroy
    UserGroup.delete(group: @group, user: @user)
    head :ok
  end
end
