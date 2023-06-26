# frozen_string_literal: true

class User < ApplicationRecord
  include HasRoles
  include Billing::Customerable

  after_create :create_chargebee_customer
  after_create :send_notification
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :services, dependent: :destroy
  has_many :robots, through: :services
  has_many :automated_tickets, dependent: :destroy

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def operationnal?
    services.joins(:automated_tickets).where(automated_tickets: { status: :ready }).present?
  end

  private

  def send_notification
    ActiveSupport::Notifications.instrument 'users.created', attributes
  end

  def create_chargebee_customer
    return if chargebee_customer_id
    return unless email

    new_chargebee_customer = ChargeBee::Customer.create({
                                                          email:,
                                                          cf_holder_id: id,
                                                          cf_holder_type: self.class.name,
                                                          taxability: 'exempt'
                                                        }).customer
    update!(chargebee_customer_id: new_chargebee_customer.id)
  end

  def customer_billing_client_internal_id
    chargebee_customer_id
  end

  def billing_client_id_attribute
    :chargebee_customer_id
  end
end
