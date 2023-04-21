# typed: true
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module PayByPhone
      class Client
        extend T::Sig
        include Cachable
        class << self
          extend T::Sig
          sig do
            params(username: String,
                   password: String)
              .returns(T::Hash[
              String,
              T.any(
                String,
                T::Array[T.untyped],
                T::Hash[T.untyped, T.untyped]
              )])
          end
          def auth(username, password)
            HttpClient.post(
              url: 'https://auth.paybyphoneapis.com/token',
              body: URI.encode_www_form({
                                          grant_type: 'password',
                                          username:,
                                          password:,
                                          client_id: 'paybyphone_web'
                                        }),
              headers: {
                'Accept' => 'application/json, text/plain, */*',
                'X-Pbp-ClientType' => 'WebApp'
              },
              use_proxy: true
            ).body
          end

          sig { params(token: String).returns(String) }
          def account_id(token)
            HttpClient.get(
              url: 'https://consumer.paybyphoneapis.com/parking/accounts',
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-pbp-clienttype': 'WebApp',
                'x-pbp-version': '2'
              },
              token:,
              use_proxy: true
            ).body.dig(0, 'id')
          end

          sig { params(token: String, account_id: String, zipcode: String, license_plate: String).returns(Array) }
          def rate_options(token, account_id, zipcode, license_plate)
            HttpClient.get(
              url: "https://consumer.paybyphoneapis.com/parking/locations/#{zipcode}/rateOptions",
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-pbp-clienttype': 'WebApp',
                'x-pbp-version': '2'
              },
              params: {
                parkingAccountId: account_id,
                licensePlate: license_plate
              },
              token:,
              use_proxy: true
            ).body
          end

          sig { params(token: String).returns(T::Array[T::Hash[String, T.untyped]]) }
          def vehicles(token)
            HttpClient.get(
              url: 'https://consumer.paybyphoneapis.com/identity/profileservice/v1/members/vehicles/paybyphone',
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-pbp-clienttype': 'WebApp'
              },
              token:,
              use_proxy: true
            ).body
          end

          sig { params(token: String, account_id: String).returns(T::Array[T::Hash[String, T.untyped]]) }
          def running_tickets(token, account_id)
            HttpClient.get(
              url: "https://consumer.paybyphoneapis.com/parking/accounts/#{account_id}/sessions?periodType=Current",
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-pbp-clienttype': 'WebApp',
                'x-pbp-version': '2'
              },
              token:,
              use_proxy: true
            ).body
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
            HttpClient.get(
              url: "https://consumer.paybyphoneapis.com/parking/accounts/#{account_id}/quote",
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-pbp-clienttype': 'WebApp',
                'x-pbp-version': '2'
              },
              params: {
                locationId: zipcode,
                licensePlate: license_plate,
                rateOptionId: rate_option_id,
                durationTimeUnit: time_unit,
                durationQuantity: quantity,
                isParkUntil: false,
                parkingAccountId: account_id
              },
              token:,
              use_proxy: true
            ).body
          end

          sig { params(token: String).returns(T::Hash[String, T::Array[T::Hash[String, T.untyped]]]) }
          def payment_methods(token)
            HttpClient.get(
              url: 'https://payments.paybyphoneapis.com/v1/accounts',
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-api-key': 'zZ4ePLvoBBD1YwBGCo6P5DiPLDjSss3j',
                'x-pbp-clienttype': 'WebApp',
                Referer: 'https://m2.paybyphone.fr/',
                'Referrer-Policy': 'strict-origin-when-cross-origin'
              },
              token:,
              use_proxy: true
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

            HttpClient.post(
              url: "https://consumer.paybyphoneapis.com/parking/accounts/#{account_id}/sessions/",
              headers: {
                accept: 'application/json, text/plain, */*',
                'accept-language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
                'content-type': 'application/json',
                'sec-fetch-dest': 'empty',
                'sec-fetch-mode': 'cors',
                'sec-fetch-site': 'cross-site',
                'x-pbp-clienttype': 'WebApp',
                'x-pbp-distributionchannel': 'pbp-webapp',
                'x-pbp-version': '2'
              },
              body: JSON.generate(final_data),
              token:,
              use_proxy: true
            ).body
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

        sig { returns(T::Boolean) }
        def valid_credentials?
          !!token
        end

        sig { returns(T::Array[T::Hash[String, T.untyped]]) }
        def vehicles
          cached(cache_key: build_cache_key('vehicles'), expires_in: 1200) do
            self.class.vehicles(token)
          end
        end

        sig { params(zipcode: String, license_plate: String).returns(T::Array[T::Hash[String, T.untyped]]) }
        def rate_options(zipcode, license_plate)
          cached(cache_key: build_cache_key('rate_options', zipcode, license_plate), expires_in: 1200) do
            self.class.rate_options(token, account_id, zipcode, license_plate)
          end
        end

        sig { returns(T::Array[T::Hash[String, T.untyped]]) }
        def running_tickets
          cached(cache_key: build_cache_key('running_tickets'), expires_in: 1200) do
            self.class.running_tickets(token, account_id)
          end
        end

        sig { returns(T::Hash[String, T::Array[T::Hash[String, T.untyped]]]) }
        def payment_methods
          cached(cache_key: build_cache_key('payment_methods'), expires_in: 1200) do
            self.class.payment_methods(token)
          end
        end

        sig do
          params(rate_option_id: String, zipcode: String, license_plate: String, quantity: Integer,
                 time_unit: String).returns(T::Hash[String, T.untyped])
        end
        def quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
          cached(cache_key: build_cache_key('quote', rate_option_id, zipcode, license_plate, quantity, time_unit),
                 expires_in: 1200) do
            self.class.quote(token, account_id, rate_option_id, zipcode, license_plate, quantity, time_unit)
          end
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
          @token ||= cached(cache_key: build_cache_key('auth'), expires_in: 1200) do
            self.class.auth(@username, @password).fetch('access_token')
          end
        end

        sig { returns(String) }
        def account_id
          @account_id ||= cached(cache_key: build_cache_key('account_id'),
                                 expires_in: 1200) do
            self.class.account_id(token)
          end
        end

        sig { params(method_name: String, method_args: T.untyped).returns(String) }
        def build_cache_key(method_name, *method_args)
          ['client/pay_by_phone', @username, @password, method_name, *method_args].join('/')
        end
      end
    end
  end
end
