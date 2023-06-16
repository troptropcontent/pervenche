# frozen_string_literal: true
# typed: strict

module Billable
  module Clients
    module ChargeBee
      class Customer
        class << self
          extend T::Sig

          sig { params(customer_id: String).returns(T.nilable(Billable::Customer::Base)) }
          def find(customer_id)
            response = get_client(path: "/#{customer_id}")
            return unless response.status == 200

            customer_hash = response.body['customer']
            build_customer(customer_hash)
          end

          sig { params(filter_params: T::Hash[String, T.untyped]).returns(T::Array[Billable::Customer::Base]) }
          def list(filter_params: {})
            response = get_client(params: filter_params)
            return [] unless response.status == 200

            customers_array = response.body.fetch('list')
            customers_array.map! do |customer_hash|
              build_customer(customer_hash['customer'])
            end
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

          sig { params(customer_hash: T::Hash[String, T.untyped]).returns(Billable::Customer::Base) }
          def build_customer(customer_hash)
            Billable::Customer::Base.new(
              customer_billing_client_internal_id: customer_hash['id'],
              email: customer_hash['email'],
              first_name: customer_hash['first_name'],
              last_name: customer_hash['last_name'],
              payment_method_valid: customer_hash['card_status'] != 'no_card',
              payment_method_status: customer_hash['card_status'],
              deleted: customer_hash['deleted']
            )
          end
        end
      end
    end
  end
end
