class UsersController < ApplicationController
  skip_load_and_authorize_resource

  def index
    current_user.authorize! :index, User
    @users = User.where.not(id: current_user.id).order(:id)
  end

  def impersonate
    current_user.authorize! :impersonate, User
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    true_user.authorize! :stop_impersonating, User
    stop_impersonating_user
    redirect_to root_path
  end
end
