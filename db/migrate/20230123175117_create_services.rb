class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :integer, null: false, default: 0
      t.string :name, null: false
      t.string :username, null: false
      t.string :password, null: false

      t.timestamps
    end
  end
end
