ChargeBee.configure(Rails.application.credentials.dig(
                      :chargebee,
                      ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox
                    ))
