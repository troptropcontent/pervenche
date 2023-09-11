class Billing::InvoicesController < ApplicationController
  skip_load_and_authorize_resource
  before_action :load_subscription!
  before_action :authorize_subscription!

  # GET /billing/customers/:customer_customer_id/invoices
  def index
    @back_link = Ui::Link.new(
      path: billing_customer_path(customer_id: @subscription.customer_id),
      action: :get,
      icon: 'chevron_left'
    )

    @invoices = @subscription.invoices
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

  def load_subscription!
    @subscription = Billing::Subscription.find(params[:subscription_subscription_id])
  end

  def authorize_subscription!
    authorize! action_name.to_sym, @subscription
  end
end
