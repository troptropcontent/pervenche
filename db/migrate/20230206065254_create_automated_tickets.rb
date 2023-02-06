class CreateAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :automated_tickets do |t|
      t.references :service, null: false, foreign_key: true
      t.string :type, null: false
      t.string :rate_option_client_internal_id, null: false
      t.string :license_plate, null: false
      t.string :zipcode, null: false
      t.integer :quantity, null: false
      t.string :time_unit, null: false
      t.string :payment_method_client_internal_id, null: false

      t.timestamps
    end
  end
end
