class PopulateVehicleTypeVehicleDescriptionLocalisationInAutomatedTickets < ActiveRecord::Migration[7.0]
  def up
    # AutomatedTicket.ready.find_each do |automated_ticket|
    #   vehicle_in_client = automated_ticket.service.vehicles.find do |vehicle|
    #     vehicle.license_plate == automated_ticket.license_plate
    #   end
    #   automated_ticket.update_columns(
    #     vehicle_type: vehicle_in_client.vehicle_type,
    #     vehicle_description: vehicle_in_client.vehicle_description,
    #     localisation: 'paris'
    #   )
    end
  end
end