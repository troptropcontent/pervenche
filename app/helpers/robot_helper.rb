module RobotHelper
  def ticket_coverage(ticket)
    starts_on = ticket.starts_on.strftime('%d/%m %H:%M')
    ends_on = ticket.ends_on.strftime('%d/%m %H:%M')
    t 'models.ticket.coverage', starts_on:, ends_on:
  end
end
