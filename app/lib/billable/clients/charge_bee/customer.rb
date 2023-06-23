# frozen_string_literal: true
# typed: strict

module Billable
  module Clients
    module ChargeBee
      class Customer
        class << self
          extend T::Sig

          sig { params(customer_id: String).returns(T.untyped) }
          def find(customer_id)
            response = get_client(path: "/#{customer_id}")
            return unless response.status == 200

            response.body
          end

          sig do
            params(
              customer_billing_client_internal_id: String,
              attributes: T.any(T::Hash[Symbol, T.untyped], ActionController::Parameters)
            )
              .returns(T.untyped)
          end
          def update_address(customer_billing_client_internal_id, attributes)
            response = Http::Client.post(
              url: "https://#{Billable.billing_client_configuration[:site]}.chargebee.com/api/v2/customers/#{customer_billing_client_internal_id}/update_billing_info",
              body: "billing_address[first_name]=#{attributes[:first_name]}&billing_address[last_name]=#{attributes[:last_name]}&billing_address[company]=#{attributes[:company]}&billing_address[line1]=#{attributes[:address]}&billing_address[city]=#{attributes[:city]}&billing_address[zip]=#{attributes[:zipcode]}&billing_address[country]=#{attributes[:country]}",
              user: Billable.billing_client_configuration[:api_key],
              raise_error: false,
              logger: false
            )
            return unless response.status == 200

            response.body.dig('customer', 'billing_address')
          end

          sig do
            params(customer_billing_client_internal_id: String,
                   redirect_url: T.nilable(String)).returns(T.nilable(String))
          end
          def update_payment_method_hosted_page_url(customer_billing_client_internal_id, redirect_url: nil)
            response = Http::Client.post(
              url: "https://#{Billable.billing_client_configuration[:site]}.chargebee.com/api/v2/hosted_pages/manage_payment_sources",
              body: "customer[id]=#{customer_billing_client_internal_id}&redirect_url=#{redirect_url}",
              user: Billable.billing_client_configuration[:api_key],
              raise_error: false,
              logger: false
            )

            return if response.status != 200

            response.body.dig('hosted_page', 'url').to_s
          end

          private

          sig { params(path: String, params: T::Hash[String, T.untyped]).returns(Faraday::Response) }
          def get_client(path: '', params: {})
            Http::Client.get(
              url: "https://#{Billable.billing_client_configuration[:site]}.chargebee.com/api/v2/customers#{path}",
              params:,
              user: Billable.billing_client_configuration[:api_key],
              raise_error: false,
              logger: false
            )
          end

          sig do
            params(customer_hash: T::Hash[String, T.untyped]).returns(Billable::Customer::Base)
          end
          def build_customer(customer_hash)
            Billable::Customer::Base.new(
              customer_billing_client_internal_id: customer_hash['id'],
              email: customer_hash['email'],
              payment_method_valid: customer_hash['card_status'] != 'no_card',
              payment_method_status: customer_hash['card_status'],
              deleted: customer_hash['deleted']
            )
          end

          sig do
            params(card_hash: T::Hash[String, T.untyped]).returns(Billable::Customer::PaymentMethod)
          end
          def build_payment_method(card_hash)
            Billable::Customer::PaymentMethod.new(
              status: card_hash['status'],
              last_four_digits: card_hash['last4'],
              card_type: card_hash['card_type'],
              funding_type: card_hash['funding_type'],
              expiry_month: card_hash['expiry_month'],
              expiry_year: card_hash['expiry_year']
            )
          end

          sig do
            params(billing_address_hash: T::Hash[String, T.untyped]).returns(Billable::Customer::Address)
          end
          def build_billing_address(billing_address_hash)
            Billable::Customer::Address.new(
              last_name: billing_address_hash['last_name'],
              first_name: billing_address_hash['first_name']
            )
          end
        end
      end
    end
  end
end
