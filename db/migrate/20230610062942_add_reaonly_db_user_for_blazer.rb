# frozen_string_literal: true

class AddReaonlyDbUserForBlazer < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      db_main_user = ActiveRecord::Base.connection.raw_connection.conninfo_hash[:user]
      db_blazer_user = Rails.application.credentials.dig(:blazer, :db_user)
      dir.up do
        db_user_password = "'#{Rails.application.credentials.dig(:blazer, :db_password)}'"
        dbname = ActiveRecord::Base.connection.current_database
        execute <<-SQL.squish
          BEGIN;
          CREATE ROLE #{db_blazer_user} LOGIN PASSWORD #{db_user_password};
          GRANT CONNECT ON DATABASE "#{dbname}" TO #{db_blazer_user};
          GRANT USAGE ON SCHEMA public TO #{db_blazer_user};
          GRANT SELECT ON ALL TABLES IN SCHEMA public TO #{db_blazer_user};
          ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO #{db_blazer_user};
          COMMIT;
        SQL
      end
      dir.down do
        execute <<-SQL.squish
          REASSIGN OWNED BY #{db_blazer_user} TO #{db_main_user};
          DROP OWNED BY #{db_blazer_user};
          DROP ROLE #{db_blazer_user};
        SQL
      end
    end
  end
end
