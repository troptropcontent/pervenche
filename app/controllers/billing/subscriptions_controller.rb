# frozen_string_literal: true

module Billing
  class SubscriptionsController < ApplicationController
    skip_load_and_authorize_resource
    before_action :load_subscription!, except: [:index]
    before_action :authorize_action!

    def index
      subscriptions = Subscription.list(filter_params: params[:filters])
      mapped_subscriptions = subscriptions.map { |subscription| mapped_subscription(subscription) }
      @rows = mapped_subscriptions.sort do |a, b|
        [a[:customer_email], a[:trial_ends_at].to_i] <=> [b[:customer_email], b[:trial_ends_at].to_i]
      end
    end

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
      authorize! action_name.to_sym, @subscription || Subscription
    end

    def mapped_subscription(subscription)
      subscription.serialize.symbolize_keys.merge({
                                                    customer_email: subscription.customer.email,
                                                    holder_status: subscription.holder&.status,
                                                    holder_active: subscription.holder&.active,
                                                    holder_license_plate: subscription.holder&.license_plate,
                                                    holder_zipcodes: subscription.holder&.zipcodes
                                                  })
    end
  end
end
