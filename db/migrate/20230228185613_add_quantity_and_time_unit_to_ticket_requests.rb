class AddQuantityAndTimeUnitToTicketRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :ticket_requests, :quantity, :integer, null: false
    add_column :ticket_requests, :time_unit, :string, null: false
  end
end
