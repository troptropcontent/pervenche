if ActiveRecord::Base.connected?
  db_user = Rails.application.credentials.dig(:blazer, :db_user)
  db_password = Rails.application.credentials.dig(:blazer, :db_password)
  db_name = ActiveRecord::Base.connection.raw_connection.conninfo_hash[:dbname]
  if (db_host = ActiveRecord::Base.connection.raw_connection.conninfo_hash[:host])
    ENV['BLAZER_DATABASE_URL'] = "postgres://#{db_user}:#{db_password}@#{db_host}:5432/#{db_name}"
  else
    db_name = ActiveRecord::Base.connection.raw_connection.conninfo_hash[:dbname]
    ENV['BLAZER_DATABASE_URL'] = "postgresql://localhost/#{db_name}?user=#{db_user}"
  end
end
