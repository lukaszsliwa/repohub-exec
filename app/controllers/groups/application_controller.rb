class Groups::ApplicationController < ApplicationController
  before_filter :find_group

  def find_group
    @group = Group.find params[:group_id]
  end
end
