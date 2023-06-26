namespace :billing do
  desc 'This task will precompile the css and save it in hugo statics'
  task update_all_customer_as_task_exempted_and_with_holder_id_and_type: :environment do
    users = User.where.not(chargebee_customer_id: nil)
    users_count = users.size
    users.find_each.with_index do |user, index|
      ap "🔄 Updating customer #{user.email} - #{index + 1}/#{users_count} 🔄}"
      customer = user.customer
      customer.update({
                        taxability: 'exempt',
                        cf_holder_id: user.id,
                        cf_holder_type: user.class.name
                      })
      ap "✅ customer #{user.email} updated ✅"
    end
  end
  task update_all_subscription_with_holder_id_and_holder_type: :environment do
    automated_tickets = AutomatedTicket.where.not(charge_bee_subscription_id: nil)
    automated_tickets_count = automated_tickets.size
    automated_tickets.find_each.with_index do |automated_ticket, index|
      ap "🔄 Updating automated_ticket #{automated_ticket.id} - #{index + 1}/#{automated_tickets_count} 🔄}"
      subscription = automated_ticket.subscription
      subscription.update({
                            cf_holder_id: automated_ticket.id,
                            cf_holder_type: automated_ticket.class.name
                          })
      ap "✅ automated_ticket #{automated_ticket.id} updated ✅"
    end
  end
end
