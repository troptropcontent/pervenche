# frozen_string_literal: true

class AddUniqueIndexOnUsernameAndKindInServices < ActiveRecord::Migration[7.0]
  def change
    add_index :services, %i[username kind], unique: true
  end
end
