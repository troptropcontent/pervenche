class ServicesController < ApplicationController
  load_and_authorize_resource
  def new; end

  def create
    if @service.save
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index; end

  private

  def service_params
    params.require(:service).permit(:username, :password, :name, :kind)
  end
end
