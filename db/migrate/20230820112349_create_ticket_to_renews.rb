class CreateTicketToRenews < ActiveRecord::Migration[7.0]
  def change
    create_view :ticket_to_renews
  end
end
