module Maillable
  class EmailJob
    include Sidekiq::Job
    sidekiq_options queue: 'mailer'

    def perform(to, template_id, template_data)
      Maillable.send_email(to:, template_id:, template_data:)
    end
  end
end
