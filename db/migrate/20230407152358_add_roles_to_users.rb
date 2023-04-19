class AddRolesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :roles, :string, array: true, default: ['customer'], null: false
    add_index :users, :roles, using: 'gin'
  end
end
