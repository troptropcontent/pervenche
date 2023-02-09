module AutomatedTickets::SetupsHelper
  def rate_option_dom_id(rate_option)
    "rate_option_client_internal_id_#{rate_option[:client_internal_id]}_#{rate_option[:accepted_time_units]}"
  end
end
