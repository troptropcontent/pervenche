require 'rails_helper'
RSpec.describe Notifications::Discord::SendMessageJob, type: :job do
  Sidekiq::Testing.fake!
  it 'is enqueued in the low queue' do
    expect { described_class.perform_async('error', 'test') }.to change(Sidekiq::Queues['low'], :size).by(1)
  end
end
