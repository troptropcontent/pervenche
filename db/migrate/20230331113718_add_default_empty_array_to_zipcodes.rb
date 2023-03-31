class AddDefaultEmptyArrayToZipcodes < ActiveRecord::Migration[7.0]
  def change
    change_column :automated_tickets, :zipcodes, :string, array: true, default: []
  end
end
