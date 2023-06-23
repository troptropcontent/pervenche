module Billing
  class CustomersController < ApplicationController
    skip_load_and_authorize_resource
    before_action :load_customer!
    before_action :authorize_customer!

    # GET /billing/customers/:customer_id
    def show
      @address = @customer.address
      @payment_method = @customer.payment_method
      @update_payment_method_hosted_page_url = @payment_method.update_payment_method_hosted_page_url(
        redirect_url: billing_customer_url(customer_id: @customer.client_id)
      )
    end

    private

    def load_customer!
      @customer = current_user.customer
    end

    def authorize_customer!
      authorize! action_name.to_sym, @customer
    end
  end
end
