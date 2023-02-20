class RobotsController < ApplicationController
  load_and_authorize_resource
  def index
    @services_setup = current_user.services.exists?
  end

  def new
    @services = current_user.services
  end

  def create
    if @robot.save
      redirect_to root_path
    else
      @services = current_user.services
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @robot = Robot.find(params[:id])
    if @robot.update(robot_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def robot_params
    params.require(:robot).permit(:name, :active, :license_plate, :zipcode, :payment_method, :duration, :service_id)
  end
end