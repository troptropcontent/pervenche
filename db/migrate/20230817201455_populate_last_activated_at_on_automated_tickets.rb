class PopulateLastActivatedAtOnAutomatedTickets < ActiveRecord::Migration[7.0]
  def up
    AutomatedTicket.where(active: true).each do |automated_ticket|
      automated_ticket.update_columns(last_activated_at: automated_ticket.updated_at)
    end
  end
end
