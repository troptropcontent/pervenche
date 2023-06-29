require 'rails_helper'
RSpec.describe Billing::Webhook::PaymentJob, type: :job do
  describe "action" do
    context "source_added" do
      context "when there is subscriptions that have been cancelled for no_card" do
        it "reactivate the cancelled subscription" 
      end
    end
  end
end
