module Billing
  class Invoice < T::Struct
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    const :id, String
    const :customer_id, String
    const :subscription_id, String
    const :status, String
    const :date, DateTime
    const :total, Integer

    class << self
      # def find(id)
      #   client_data = Billable::Clients::ChargeBee::Subscription.find(id)
      #   raise Errors::NotFound, "Subscription with id #{id} could not be found" if client_data.nil?

      #   build_subscription_from_hash(client_data)
      # end

      def list(subscription_id:)
        client_data = Billable::Clients::ChargeBee::Invoice.list(subscription_id:)
        return [] if client_data.nil?

        client_data['list'].map do |invoice_hash|
          build_invoice_from_hash(invoice_hash)
        end
      end

      private

      def build_invoice_from_hash(invoice_hash)
        new(
          id: invoice_hash.dig('invoice', 'id'),
          customer_id: invoice_hash.dig('invoice', 'customer_id'),
          subscription_id: invoice_hash.dig('invoice', 'subscription_id'),
          status: invoice_hash.dig('invoice', 'status'),
          date: build_datetime(invoice_hash.dig('invoice', 'date')),
          total: invoice_hash.dig('invoice', 'total')
        )
      end

      def build_datetime(int)
        return if int.nil?

        Time.zone.at(int).to_datetime
      end
    end

    def download_url
      return @download_url if @download_url

      client_data = Billable::Clients::ChargeBee::Invoice.pdf(invoice_id: id)
      @download_url = client_data.dig('download', 'download_url') unless client_data.nil?
    end
  end
end
