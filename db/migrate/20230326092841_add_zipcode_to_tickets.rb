# frozen_string_literal: true

class AddZipcodeToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :zipcode, :string
  end
end
