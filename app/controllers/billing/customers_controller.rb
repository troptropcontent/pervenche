module Billing
  class CustomersController < ApplicationController
    skip_load_and_authorize_resource
    before_action :load_customer!
    before_action :authorize_customer!

    # GET /billing/customers/:customer_id
    def show
      @billing_address = @customer.billing_address
      @update_payment_method_hosted_page_url = update_payment_method_hosted_page_url
      @payment_method = @customer.payment_method
    end

    private

    def load_customer!
      @customer = Billable::Customer.find(params[:customer_id])
    end

    def authorize_customer!
      authorize! action_name.to_sym, @customer
    end

    def update_payment_method_hosted_page_url
      # to test in development, use ngrok
      # redirect_url = billing_customer_url(
      #   customer_id: @customer.customer_billing_client_internal_id,
      #   host: 'e638-2001-861-8c95-8bf0-b41c-8f18-a33e-3fe6.ngrok-free.app',
      #   port: ''
      # )
      redirect_url = billing_customer_url(customer_id: @customer.customer_billing_client_internal_id)
      Billable::Customer.update_payment_method_hosted_page_url(
        @customer.customer_billing_client_internal_id,
        redirect_url:
      )
    end
  end
end
