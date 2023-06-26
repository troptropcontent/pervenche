module Billable
  module Customer
    class PaymentMethod < T::Struct
      const :status, String
      const :last_four_digits, String
      const :card_type, String
      const :funding_type, String
      const :expiry_month, Integer
      const :expiry_year, Integer
    end
  end
end
