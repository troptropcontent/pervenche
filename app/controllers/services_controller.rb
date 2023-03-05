class ServicesController < ApplicationController
  load_and_authorize_resource
  def new
    @with_navbar = false
  end

  def create
    if @service.save
      assign_default_name unless service_params[:name]
      flash[:success] = t('views.services.new.flash.success')
      redirect_to navigation_params[:redirect_to] || root_path
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

  def navigation_params
    params.permit(navigation: [:redirect_to])[:navigation]
  end
end
