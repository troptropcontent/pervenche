# frozen_string_literal: true

class AutomatedTickets::FindSimilarTicket < Actor
  input :automated_ticket
  output :zipcodes_already_covered

  def call
    self.zipcodes_already_covered = []
    automated_ticket.zipcodes&.each do |zipcode|
      zipcodes_already_covered << zipcode if similar_ticket_for_zipcode(zipcode)
    end
  end

  private

  def similar_ticket_for_zipcode(zipcode)
    AutomatedTicket.ready.where(automated_ticket.slice(:service_id, :license_plate, :kind))
                   .where(':zipcode = ANY (zipcodes)', zipcode:)
                   .where.not(id: automated_ticket.id)
                   .exists?
  end
end
