class CreateAutomatedTicketsSetups < ActiveRecord::Migration[7.0]
  def change
    create_table :automated_tickets_setups do |t|
      t.references :service, null: false, foreign_key: true
      t.string :localisation
      t.string :vehycle_type
      t.string :license_plate
      t.integer :weekdays, array: true, default: [1, 2, 3, 4, 5, 6, 0]
      t.string :payment_method_client_internal_ids, array: true
      t.string :rate_option_client_internal_id
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
