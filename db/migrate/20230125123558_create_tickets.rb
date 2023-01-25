class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.datetime :starts_on, null: false
      t.datetime :ends_on, null: false
      t.string :license_plate, null: false
      t.integer :cost_cents, null: false
      t.references :robot, null: false, foreign_key: true
      t.string :client_internal_id, null: false

      t.timestamps
    end
  end
end
