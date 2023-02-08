class CreateAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :automated_tickets do |t|
      t.references :service, foreign_key: true
      t.references :user, foreign_key: true, null: false
      t.string :type
      t.string :rate_option_client_internal_id
      t.string :license_plate
      t.string :zipcode
      t.integer :minutes
      t.string :client_time_unit
      t.string :payment_method_client_internal_id
      t.integer :status, null: false, default: 0
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
