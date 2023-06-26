module Billable
  module Customer
    class Address < T::Struct
      const :last_name, T.nilable(String)
      const :first_name, T.nilable(String)
      const :company, T.nilable(String)
      const :phone, T.nilable(String)
      const :address, T.nilable(String)
      const :city, T.nilable(String)
      const :zipcode, T.nilable(String)
      const :country, T.nilable(String)
    end
  end
end
