# frozen_string_literal: true

module Admin
  module Diagnostics
    class ClientController < ApplicationController
      def show
        @kind = params[:client_kind]
        @checkup = checker.checkup
        @state = @checkup.all? { |(_check, result)| result == 'Ok' } ? 'Ok' : 'Fail'
      end

      private

      def checker
        @checker ||= Client.new(random_service)
      end

      def random_service
        Service.joins(:automated_tickets).where(
          kind: @kind,
          automated_tickets: { status: :ready }
        ).order('RANDOM()').limit(1).first
      end
    end
  end
end
