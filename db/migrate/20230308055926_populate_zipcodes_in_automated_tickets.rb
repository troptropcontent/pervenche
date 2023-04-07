class PopulateZipcodesInAutomatedTickets < ActiveRecord::Migration[7.0]
  def up
    AutomatedTicket.find_each do |automated_ticket|
      automated_ticket.update_columns(zipcodes: [automated_ticket.zipcode])
    end
  end

  def down
    AutomatedTicket.find_each do |automated_ticket|
      automated_ticket.update_columns(zipcode: automated_ticket.zipcodes[0])
    end
  end
end
