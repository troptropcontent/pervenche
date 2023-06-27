namespace :billing do
  desc 'This task will precompile the css and save it in hugo statics'
  task update_all_customer_as_task_exempted_and_with_holder_id_and_type: :environment do
    users = User.where.not(chargebee_customer_id: nil)
    users.find_each.with_index do |user, _index|
      GenericJob.perform_async(
        'Billing::Customer',
        'update',
        {
          'taxability' => 'exempt',
          'cf_holder_id' => user.id,
          'cf_holder_type' => user.class.name
        },
        { 'find_id' => user.chargebee_customer_id }
      )
    end
  end
  task update_all_subscription_with_holder_id_and_holder_type: :environment do
    automated_tickets = AutomatedTicket.where.not(charge_bee_subscription_id: nil)
    automated_tickets.find_each.with_index do |automated_ticket, _index|
      GenericJob.perform_async(
        'Billing::Subscription',
        'update',
        {
          'cf_holder_id' => automated_ticket.id,
          'cf_holder_type' => automated_ticket.class.name
        },
        { 'find_id' => automated_ticket.charge_bee_subscription_id }
      )
    end
  end
end
