class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :checkPermission

  def index
    @user = current_user.email
  end
end
