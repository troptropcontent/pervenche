class AddActiveBooleanToRobots < ActiveRecord::Migration[7.0]
  def change
    add_column :robots, :active, :boolean, null: false, default: false
  end
end
