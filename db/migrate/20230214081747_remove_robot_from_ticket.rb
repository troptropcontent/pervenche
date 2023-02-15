class RemoveRobotFromTicket < ActiveRecord::Migration[7.0]
  def change
    remove_reference :tickets, :robot, index: true, foreign_key: true
  end
end
