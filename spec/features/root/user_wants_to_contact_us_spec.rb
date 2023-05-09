# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User wants to contact us', type: :system do
  before do
    WebMock.allow_net_connect!
    VCR.turn_off!
  end
  describe 'It opens the modal', js: true do
    it 'send us an email' do
      user = FactoryBot.create(:user)
      service = FactoryBot.build(:service, user_id: user.id)
      service.save(validate: false)
      automated_ticket = FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes: %w[75018 75017 75016])

      login_as user

      visit root_path
      menu_modal_btn = find(id: 'menu_modal_btn')
      new_automated_btn = find(id: 'new_automated_ticket_btn')

      new_automated_btn.click

      expect(page).to have_content('Hello world')
    end
  end
end
