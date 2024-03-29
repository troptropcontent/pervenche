module AutomatedTickets::SetupsHelper
  def rate_option_dom_id(rate_option)
    "rate_option_client_internal_id_#{rate_option[:client_internal_id]}_#{rate_option[:accepted_time_units]}"
  end

  def weekdays_collection
    Date::ABBR_DAYNAMES.map.with_index { |day_name, index| [day_name, index] }.rotate(1)
  end
end
