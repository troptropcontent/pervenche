module Billing
  class CustomersController < ApplicationController
    skip_load_and_authorize_resource
    before_action :load_customer!
    before_action :authorize_customer!
    # GET /billing/customers/:customer_id
    def show
      head :ok
    end

    private

    def load_customer!
      @customer = Billable::Customer.find(params[:customer_id])
    end

    def authorize_customer!
      authorize! action_name.to_sym, @customer
    end
  end
end
