class AddNameToRobots < ActiveRecord::Migration[7.0]
  def change
    add_column :robots, :name, :string, null: false
  end
end
