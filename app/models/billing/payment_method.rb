class Billing::PaymentMethod < T::Struct
  const :customer_id, String
  const :status, T.nilable(String)
  const :last_four_digits, T.nilable(String)
  const :card_type, T.nilable(String)
  const :funding_type, T.nilable(String)
  const :expiry_month, T.nilable(Integer)
  const :expiry_year, T.nilable(Integer)

  def update_payment_method_hosted_page_url(redirect_url: nil)
    Billable::Clients::ChargeBee::Customer.update_payment_method_hosted_page_url(
      customer_id,
      redirect_url:
    )
  end
end
