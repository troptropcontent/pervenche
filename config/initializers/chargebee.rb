ChargeBee.configure(Rails.application.credentials.dig(
                      :chargebee,
                      ENV['PERVENCHE_CHARGEBEE_ENABLED'] ? :production : :sandbox
                    ))
