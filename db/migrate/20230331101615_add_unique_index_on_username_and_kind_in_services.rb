class AddUniqueIndexOnUsernameAndKindInServices < ActiveRecord::Migration[7.0]
  def change
    add_index :services, [:username, :kind], unique: true
  end
end
