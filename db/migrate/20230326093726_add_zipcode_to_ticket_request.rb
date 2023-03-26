class AddZipcodeToTicketRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :ticket_requests, :zipcode, :string
  end
end
