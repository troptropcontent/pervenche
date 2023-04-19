# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { FactoryBot.build(:user, roles:) }
  let(:roles) { %w[customer] }
  describe 'roles' do
    describe 'validations' do
      describe 'handled_roles_only' do
        context 'when the roles array contains an unhandled role' do
          let(:roles) { %w[customer bidule machin] }
          it 'is not valid' do
            expect(user).to be_invalid
            expect(user.errors.messages[:roles]).to include("Le role bidule n'est pas pris en compte")
          end
        end
        context 'when the roles array contains only handled roles' do
          it 'is not valid' do
            expect(user).to be_valid
          end
        end
      end
      describe 'uniq_values' do
        context 'when the roles array contains a diplicate value' do
          let(:roles) { %w[customer customer] }
          it 'is not valid' do
            expect(user).to be_invalid
            expect(user.errors.messages[:roles]).to include('Plusieurs role identiques on été detectés')
          end
        end
        context 'when the roles array contains only handled roles' do
          let(:roles) { %w[customer admin] }
          it 'is not valid' do
            expect(user).to be_valid
          end
        end
      end
    end

    describe 'instance_methods' do
      context '#add_role' do
        context 'when the role is valid' do
          it 'add the role' do
            expect(user.add_role('admin')).to eq(true)
            expect(user.roles).to eq(%w[customer admin])
          end
        end
        context 'when the role is already there' do
          it 'add the role' do
            expect(user.add_role('customer')).to eq(nil)
            expect(user.roles).to eq(%w[customer])
          end
        end
        context 'when the role is not valid' do
          it 'add the role' do
            expect do
              user.add_role('bidule')
            end.to raise_error(ActiveRecord::RecordInvalid,
                               "La validation a échoué : Roles Le role bidule n'est pas pris en compte")
          end
        end
      end
      context '#remove_role' do
        context 'when the role is there' do
          let(:roles) { %w[customer admin] }
          it 'remove the role' do
            expect(user.remove_role('admin')).to eq(true)
            expect(user.roles).to eq(%w[customer])
          end
        end
        context 'when the role is there' do
          let(:roles) { %w[admin] }
          it 'remove the role' do
            expect(user.remove_role('customer')).to eq(nil)
            expect(user.roles).to eq(%w[admin])
          end
        end
      end
      context '#has_role' do
        context 'when the user has role' do
          it 'returns true' do
            expect(user.has_role?('customer')).to eq(true)
          end
        end
        context 'when the user has not the role' do
          it 'returns false' do
            expect(user.has_role?('admin')).to eq(false)
          end
        end
      end
    end
  end
end
