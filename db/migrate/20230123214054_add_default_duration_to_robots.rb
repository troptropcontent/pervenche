class AddDefaultDurationToRobots < ActiveRecord::Migration[7.0]
  def change
    change_column_default :robots, :duration, 1
  end
end
