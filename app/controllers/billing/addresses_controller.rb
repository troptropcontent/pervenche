class Billing::AddressesController < ApplicationController
  skip_load_and_authorize_resource
  before_action :load_customer!
  before_action :load_address
  before_action :authorize_customer!

  # GET /billing/customers/:customer_customer_id/address/edit
  def edit; end

  # PUT /billing/customers/:customer_customer_id/address
  def update
    @address.update!(address_params)
    redirect_to billing_customer_path(customer_id: @address.customer_id)
  end

  private

  def address_params
    params.require(:address).permit(
      :first_name,
      :last_name,
      :address,
      :city,
      :company,
      :zipcode
    )
  end

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
