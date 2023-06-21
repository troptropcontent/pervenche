class Billing::BillingAddressesController < ApplicationController
  skip_load_and_authorize_resource
  before_action :load_customer!
  before_action :authorize_customer!
  # PUT /billing/customers/:customer_customer_id/billing_address
  def update; end

  private

  def load_customer!
    @customer = Billable::Customer.find(params[:customer_id])
  end

  def authorize_customer!
    authorize! action_name.to_sym, @customer
  end
end
