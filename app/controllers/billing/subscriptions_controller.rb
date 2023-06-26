module Billing
  class SubscriptionsController < ApplicationController
    skip_load_and_authorize_resource
    before_action :load_subscription!
    before_action :authorize_action!

    def new; end

    # DELETE /billing/subscriptions/:subscription_id
    def destroy
      @subscription.destroy
      redirect_to billing_customer_path(customer_id: @subscription.customer_id)
    end

    private

    def load_subscription!
      @subscription = Subscription.find(params[:subscription_id])
    end

    def authorize_action!
      authorize! action_name.to_sym, @subscription
    end
  end
end
