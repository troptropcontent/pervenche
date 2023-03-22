# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
require 'support/shared_context/service_stubs'

RSpec.describe AutomatedTicket::Setup::Updater, type: :actor do
  include_context 'a user with a service with an automated ticket', :payment_methods
  include_context 'a stubed service'
  describe '.call' do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
