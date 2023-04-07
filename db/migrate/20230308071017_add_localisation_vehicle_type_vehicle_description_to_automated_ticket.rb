class AddLocalisationVehicleTypeVehicleDescriptionToAutomatedTicket < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :vehicle_type, :string
    add_column :automated_tickets, :vehicle_description, :string
    add_column :automated_tickets, :localisation, :string
  end
end
