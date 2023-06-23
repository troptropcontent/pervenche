class Billing::AddressesController < ApplicationController
  skip_load_and_authorize_resource
  before_action :load_customer!
  before_action :load_address
  before_action :authorize_customer!

  
  # PUT /billing/customers/:customer_customer_id/address
  def update; end

  # GET /billing/customers/:customer_customer_id/address/edit
  def edit; end

  private

  def load_customer!
    @customer = Billing::Customer.find(params[:customer_id])
  end

  def load_address
    @address = @customer.address
  end

  def authorize_customer!
    authorize! action_name.to_sym, @address
  end
end
