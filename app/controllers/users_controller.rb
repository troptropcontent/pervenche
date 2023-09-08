# frozen_string_literal: true

class UsersController < ApplicationController
  skip_load_and_authorize_resource
  before_action :require_admin!
  def index
    @users = User.where.not(id: current_user.id).order(:id)
  end

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  private

  def require_admin!
    true_user.authorize! action_name.to_sym, User
  end
end
