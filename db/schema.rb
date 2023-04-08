# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_407_152_358) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'automated_tickets', force: :cascade do |t|
    t.bigint 'service_id'
    t.bigint 'user_id', null: false
    t.string 'type'
    t.string 'rate_option_client_internal_id'
    t.string 'license_plate'
    t.integer 'status', default: 0, null: false
    t.boolean 'active', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'weekdays', array: true
    t.string 'accepted_time_units', array: true
    t.string 'zipcodes', default: [], array: true
    t.string 'payment_method_client_internal_ids', array: true
    t.string 'vehicle_type'
    t.string 'vehicle_description'
    t.string 'localisation'
    t.boolean 'free', default: false
    t.index ['service_id'], name: 'index_automated_tickets_on_service_id'
    t.index ['user_id'], name: 'index_automated_tickets_on_user_id'
  end

  create_table 'automated_tickets_setups', force: :cascade do |t|
    t.bigint 'service_id', null: false
    t.string 'localisation'
    t.string 'vehycle_type'
    t.string 'license_plate'
    t.integer 'weekdays', default: [1, 2, 3, 4, 5, 6, 0], array: true
    t.string 'payment_method_client_internal_ids', array: true
    t.string 'rate_option_client_internal_id'
    t.integer 'status', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['service_id'], name: 'index_automated_tickets_setups_on_service_id'
  end

  create_table 'robots', force: :cascade do |t|
    t.bigint 'service_id', null: false
    t.string 'license_plate', null: false
    t.string 'payment_method', null: false
    t.string 'zipcode', null: false
    t.integer 'duration', default: 1, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'name', null: false
    t.boolean 'active', default: false, null: false
    t.index ['service_id'], name: 'index_robots_on_service_id'
  end

  create_table 'services', force: :cascade do |t|
    t.string 'integer', default: '0', null: false
    t.string 'name'
    t.string 'username', null: false
    t.string 'password', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id', null: false
    t.integer 'kind'
    t.index ['user_id'], name: 'index_services_on_user_id'
    t.index %w[username kind], name: 'index_services_on_username_and_kind', unique: true
  end

  create_table 'ticket_requests', force: :cascade do |t|
    t.bigint 'automated_ticket_id', null: false
    t.string 'payment_method_client_internal_id'
    t.datetime 'requested_on', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'quantity', null: false
    t.string 'time_unit', null: false
    t.string 'zipcode'
    t.index ['automated_ticket_id'], name: 'index_ticket_requests_on_automated_ticket_id'
  end

  create_table 'tickets', force: :cascade do |t|
    t.datetime 'starts_on', null: false
    t.datetime 'ends_on', null: false
    t.string 'license_plate', null: false
    t.integer 'cost_cents', null: false
    t.string 'client_internal_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'automated_ticket_id', null: false
    t.string 'zipcode'
    t.index ['automated_ticket_id'], name: 'index_tickets_on_automated_ticket_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'provider'
    t.string 'uid'
    t.string 'roles', default: ['customer'], null: false, array: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'automated_tickets', 'services'
  add_foreign_key 'automated_tickets', 'users'
  add_foreign_key 'automated_tickets_setups', 'services'
  add_foreign_key 'robots', 'services'
  add_foreign_key 'services', 'users'
  add_foreign_key 'ticket_requests', 'automated_tickets'
  add_foreign_key 'tickets', 'automated_tickets'
end
