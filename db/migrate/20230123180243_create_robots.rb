class CreateRobots < ActiveRecord::Migration[7.0]
  def change
    create_table :robots do |t|
      t.references :service, null: false, foreign_key: true
      t.string :license_plate, null: false
      t.string :payment_method, null: false
      t.string :zipcode, null: false
      t.integer :duration, null: false

      t.timestamps
    end
  end
end
