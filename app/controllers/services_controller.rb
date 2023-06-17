# frozen_string_literal: true

class ServicesController < ApplicationController
  def new
    @redirect_to = navigation_params&.dig(:redirect_to)
  end

  def edit; end

  def create
    assign_default_name unless service_params[:name]
    if @service.save
      flash[:notice] = t('views.services.new.flash.success')
      redirect_to root_path
    else
      flash[:alert] = t('views.services.new.flash.alert')
      render 'new', status: :unprocessable_entity
    end
  end

  # POST /services/:id
  def update
    if @service.update(service_params)
      flash[:notice] = t('views.services.edit.flash.success')
      redirect_to root_path
    else
      flash[:alert] = t('views.services.edit.flash.alert')
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def service_params
    params.require(:service).permit(:username, :password, :name, :kind)
  end

  def assign_default_name
    @service.name = "#{t("models.service.attributes.kind.enum.#{@service.kind}")} - #{@service.username}"
  end

  def navigation_params
    params.require(:navigation).permit(:redirect_to)
  end
end
