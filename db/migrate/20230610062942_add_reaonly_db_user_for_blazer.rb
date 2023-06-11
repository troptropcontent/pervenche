# frozen_string_literal: true

class AddReaonlyDbUserForBlazer < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        db_user_password = "'#{Rails.application.credentials.dig(:blazer, :db_password)}'"
        dbname = ActiveRecord::Base.connection.current_database
        execute <<-SQL.squish
          BEGIN;
          CREATE ROLE blazer LOGIN PASSWORD #{db_user_password};
          GRANT CONNECT ON DATABASE #{dbname} TO blazer;
          GRANT USAGE ON SCHEMA public TO blazer;
          GRANT SELECT ON ALL TABLES IN SCHEMA public TO blazer;
          ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO blazer;
          COMMIT;
        SQL
      end
      dir.down do
        execute <<-SQL.squish
          DROP ROLE blazer
        SQL
      end
    end
  end
end
