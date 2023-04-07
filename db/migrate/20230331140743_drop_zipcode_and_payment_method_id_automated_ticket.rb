# frozen_string_literal: true

class DropZipcodeAndPaymentMethodIdAutomatedTicket < ActiveRecord::Migration[7.0]
  def change
    remove_column :automated_tickets, :payment_method_client_internal_id, :string
    remove_column :automated_tickets, :zipcode, :string
  end
end
