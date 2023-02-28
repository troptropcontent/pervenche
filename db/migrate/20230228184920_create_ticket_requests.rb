class CreateTicketRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_requests do |t|
      t.references :automated_ticket, null: false, foreign_key: true
      t.string :payment_method_client_internal_id, null: false
      t.datetime :requested_on, null: false

      t.timestamps
    end
  end
end
