# frozen_string_literal: true

require 'rails_helper'

module Admin::Diagnostics
  RSpec.describe Client, type: :model do
    subject { described_class.new(service) }
    let(:service) do
      service = FactoryBot.build(:service, username:, password:, kind:, user:)
      service.save(validate: false)
      service
    end
    let!(:user) { FactoryBot.create(:user) }
    let(:username) { 'a_fake_username' }
    let(:password) { 'a_fake_password' }
    let(:kind) { 'pay_by_phone' }
    let!(:automated_ticket) do
      FactoryBot.create(:automated_ticket, :set_up, service:, user:, license_plate: 'CL123UU', zipcodes: [zipcode],
                                                    rate_option_client_internal_id: '1085252721', accepted_time_units: ['days'])
    end
    let(:zipcode) { '75018' }
    describe '.class_methods' do
      context 'pay_by_phone' do
        describe 'vehicles' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_vehicles') do
                expect(described_class.vehicles(service)).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_vehicles_fail') do
                expect(described_class.vehicles(service)).to eq('Fail')
              end
            end
          end
        end
        describe 'rate_options' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_rate_options') do
                expect(described_class.rate_options(service)).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            let(:zipcode) { '77888' }
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_rate_options_fail') do
                expect(described_class.rate_options(service)).to eq('Fail')
              end
            end
          end
        end
        describe 'payment_methods' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_payment_methods') do
                expect(described_class.payment_methods(service)).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_payment_methods_fail') do
                expect(described_class.payment_methods(service)).to eq('Fail')
              end
            end
          end
        end
        describe 'running_ticket' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_running_ticket') do
                expect(described_class.running_ticket(service)).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_running_ticket_fail') do
                expect(described_class.running_ticket(service)).to eq('Fail')
              end
            end
          end
        end
        describe 'quote' do
          let(:zipcode) { '75019' }
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_quote') do
                expect(described_class.quote(service)).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_quote_fail') do
                expect(described_class.quote(service)).to eq('Fail')
              end
            end
          end
        end
      end
    end
    describe '#instance_methods' do
      context 'pay_by_phone' do
        describe 'vehicles' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_vehicles') do
                expect(subject.vehicles).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_vehicles_fail') do
                expect(subject.vehicles).to eq('Fail')
              end
            end
          end
        end
        describe 'rate_options' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_rate_options') do
                expect(subject.rate_options).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            let(:zipcode) { '77888' }
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_rate_options_fail') do
                expect(subject.rate_options).to eq('Fail')
              end
            end
          end
        end
        describe 'payment_methods' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_payment_methods') do
                expect(subject.payment_methods).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_payment_methods_fail') do
                expect(subject.payment_methods).to eq('Fail')
              end
            end
          end
        end
        describe 'running_ticket' do
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_running_ticket') do
                expect(subject.running_ticket).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_running_ticket_fail') do
                expect(subject.running_ticket).to eq('Fail')
              end
            end
          end
        end
        describe 'quote' do
          let(:zipcode) { '75019' }
          context 'when no error is raised' do
            it 'returns Ok' do
              VCR.use_cassette('pay_by_phone_quote') do
                expect(subject.quote).to eq('Ok')
              end
            end
          end
          context 'when and error is raised' do
            it 'returns Fail' do
              VCR.use_cassette('pay_by_phone_quote_fail') do
                expect(subject.quote).to eq('Fail')
              end
            end
          end
        end
      end
    end
  end
end
