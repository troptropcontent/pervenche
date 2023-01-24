class AddKindToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :kind, :integer
  end
end
