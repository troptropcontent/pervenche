module Billable
  module Customer
    class Base < T::Struct
      const :customer_billing_client_internal_id, String
      const :email, String
      const :payment_method_valid, T::Boolean
      const :payment_method_status, String
      const :deleted, T::Boolean

      prop :billing_address, T.nilable(Address)
      prop :payment_method, T.nilable(PaymentMethod)
    end
  end
end
