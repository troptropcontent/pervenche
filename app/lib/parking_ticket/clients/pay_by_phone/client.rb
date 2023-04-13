# typed: true
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module PayByPhone
      class Client
        extend T::Sig
        class << self
          extend T::Sig
          sig { params(username: String, password: String).returns(Faraday::Response) }
          def auth(username, password)
            conn = Faraday.new('https://auth.paybyphoneapis.com') do |f|
              f.response :json
            end

            conn.post(
              '/token',
              URI.encode_www_form({
                                    grant_type: 'password',
                                    username:,
                                    password:,
                                    client_id: 'paybyphone_web'
                                  }),
              {
                'Accept' => 'application/json, text/plain, */*',
                'X-Pbp-ClientType' => 'WebApp'
              }
            )
          end

          sig { params(token: String, account_id: String, zipcode: String, license_plate: String).returns(Array) }
          def rate_options(token, account_id, zipcode, license_plate)
            connection(token).get("/parking/locations/#{zipcode}/rateOptions",
                                  {
                                    parkingAccountId: account_id,
                                    licensePlate: license_plate
                                  }).body
          end

          sig { params(token: String).returns(T::Array[T::Hash[String, T.untyped]]) }
          def vehicles(token)
            connection(token).get('/identity/profileservice/v1/members/vehicles/paybyphone').body
          end

          sig { params(token: String).returns(String) }
          def account_id(token)
            connection(token).get('/parking/accounts').body.dig(0, 'id')
          end

          sig { params(token: String, account_id: String).returns(T::Array[T::Hash[String, T.untyped]]) }
          def running_tickets(token, account_id)
            connection(token).get("/parking/accounts/#{account_id}/sessions?periodType=Current").body
          end

          sig do
            params(
              token: String,
              account_id: String,
              rate_option_id: String,
              zipcode: String,
              license_plate: String,
              quantity: Integer,
              time_unit: String
            ).returns(T::Hash[String, T.untyped])
          end
          def quote(token, account_id, rate_option_id, zipcode, license_plate, quantity, time_unit)
            connection(token).get(
              "/parking/accounts/#{account_id}/quote",
              {
                locationId: zipcode,
                licensePlate: license_plate,
                rateOptionId: rate_option_id,
                durationTimeUnit: time_unit,
                durationQuantity: quantity,
                isParkUntil: false,
                parkingAccountId: account_id
              }
            ).body
          end

          sig do
            params(
              token: String,
              account_id: String,
              license_plate: String,
              zipcode: String,
              rate_option_client_internal_id: String,
              quantity: Integer,
              time_unit: String,
              quote_client_internal_id: String,
              starts_on: DateTime,
              payment_method_id: T.nilable(String)
            ).void
          end
          def new_ticket(token, account_id, license_plate:, zipcode:, rate_option_client_internal_id:, quantity:,
                         time_unit:, quote_client_internal_id:, starts_on:, payment_method_id:)
            base_data = {
              expireTime: nil,
              duration: {
                quantity: quantity.to_s,
                timeUnit: time_unit
              },
              licensePlate: license_plate,
              locationId: zipcode,
              rateOptionId: rate_option_client_internal_id,
              startTime: starts_on.to_s,
              quoteId: quote_client_internal_id,
              parkingAccountId: account_id
            }

            payment_data = {
              paymentMethod: {
                paymentMethodType: 'PaymentAccount',
                payload: {
                  paymentAccountId: payment_method_id,
                  clientBrowserDetails: {
                    browserAcceptHeader: 'text/html',
                    browserColorDepth: '30',
                    browserJavaEnabled: 'false',
                    browserLanguage: 'fr-FR',
                    browserScreenHeight: '900',
                    browserScreenWidth: '1440',
                    browserTimeZone: '-60',
                    browserUserAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'
                  }
                }
              }
            }

            final_data = payment_method_id ? base_data.merge(payment_data) : base_data

            connection(token).post(
              "/parking/accounts/#{account_id}/sessions/",
              JSON.generate(final_data)
            ).body
          end

          sig { params(token: String).returns(T::Hash[String, T::Array[T::Hash[String, T.untyped]]]) }
          def payment_methods(token)
            connection = Faraday.new(
              url: 'https://payments.paybyphoneapis.com',
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                authorization: "Bearer #{token}",
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-api-key': 'zZ4ePLvoBBD1YwBGCo6P5DiPLDjSss3j',
                'x-pbp-clienttype': 'WebApp',
                Referer: 'https://m2.paybyphone.fr/',
                'Referrer-Policy': 'strict-origin-when-cross-origin'
              }
            ) do |f|
              f.response :json
              f.response :raise_error
            end

            connection.get('/v1/accounts').body
          end

          private

          sig { params(token: String, subdomain: T.nilable(String)).returns(Faraday::Connection) }
          def connection(token, subdomain: 'consumer')
            Faraday.new(
              url: "https://#{subdomain}.paybyphoneapis.com",
              headers: {
                'Content-Type' => 'application/json',
                'Authorization' => "Bearer #{token}",
                'Referer' => 'https://m2.paybyphone.fr/'
              }
            ) do |f|
              f.response :json
              f.response :raise_error
            end
          end
        end

        def initialize(username, password)
          @username = username
          @password = password
        end

        sig { returns(T::Array[T::Hash[String, T.untyped]]) }
        def vehicles
          self.class.vehicles(token)
        end

        sig { params(zipcode: String, license_plate: String).returns(T::Array[T::Hash[String, T.untyped]]) }
        def rate_options(zipcode, license_plate)
          self.class.rate_options(token, account_id, zipcode, license_plate)
        end

        sig { returns(T::Array[T::Hash[String, T.untyped]]) }
        def running_tickets
          self.class.running_tickets(token, account_id)
        end

        sig { returns(T::Hash[String, T::Array[T::Hash[String, T.untyped]]]) }
        def payment_methods
          self.class.payment_methods(token)
        end

        sig do
          params(rate_option_id: String, zipcode: String, license_plate: String, quantity: Integer,
                 time_unit: String).returns(T::Hash[String, T.untyped])
        end
        def quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
          self.class.quote(token, account_id, rate_option_id, zipcode, license_plate, quantity, time_unit)
        end

        sig do
          params(
            license_plate: String,
            zipcode: String,
            rate_option_client_internal_id: String,
            quantity: Integer,
            time_unit: String,
            quote_client_internal_id: String,
            starts_on: DateTime,
            payment_method_id: T.nilable(String)
          )
            .void
        end
        def new_ticket(license_plate:, zipcode:, rate_option_client_internal_id:, quantity:, time_unit:,
                       quote_client_internal_id:, starts_on:, payment_method_id:)
          self.class.new_ticket(token, account_id,
                                license_plate:,
                                zipcode:,
                                rate_option_client_internal_id:,
                                quantity:,
                                time_unit:,
                                quote_client_internal_id:,
                                starts_on:,
                                payment_method_id:)
        end

        private

        sig { returns(String) }
        def token
          @token ||= self.class.auth(@username, @password).body['access_token']
        end

        sig { returns(String) }
        def account_id
          @account_id ||= self.class.account_id(token)
        end
      end
    end
  end
end
