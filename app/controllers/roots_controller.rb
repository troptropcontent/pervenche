class RootsController < ApplicationController
  skip_load_and_authorize_resource
  def index
    if current_user.has_role?('admin')
      redirect_to users_path
    else
      redirect_to automated_tickets_path
    end
  end
end
