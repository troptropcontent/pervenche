# frozen_string_literal: true

class ServicesController < ApplicationController
  def index; end

  def new
    @with_navbar = false
    @redirect_to = navigation_params&.dig(:redirect_to)
  end

  def create
    if @service.save
      assign_default_name unless service_params[:name]
      flash[:notice] = t('views.services.new.flash.success')
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def service_params
    params.require(:service).permit(:username, :password, :name, :kind).compact_blank
  end

  def assign_default_name
    @service.name = "#{t("models.service.attributes.kind.enum.#{@service.kind}")} - #{@service.username}"
    @service.save
  end

  def navigation_params
    params.require(:navigation).permit(:redirect_to)
  end
end
