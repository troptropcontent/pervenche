class Admin::Diagnostics::TicketsToRenewController < ApplicationController
  def show
    @checkup = Admin::Diagnostics::TicketsToRenew.new.checkup
    @state = @checkup[:total_number_of_tickets_to_take].zero? ? 'Ok' : 'Fail'
  end
end
