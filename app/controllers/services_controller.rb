class ServicesController < ApplicationController
  load_and_authorize_resource
  def new; end

  def create
    if @service.save
      assign_default_name unless service_params[:name]
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index; end

  private

  def service_params
    params.require(:service).permit(:username, :password, :name, :kind).compact_blank
  end

  def assign_default_name
    @service.name = "#{t("models.service.attributes.kind.enum.#{@service.kind}")} - #{@service.username}"
    @service.save
  end
end
