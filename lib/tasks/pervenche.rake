namespace :pervenche do
  desc 'This task will precompile the css and save it in hugo statics'
  task :sync_css do
    sh 'bundle exec rake assets:precompile --trace'
    sh "find ./public/assets -type f -iname \"application-*.css\" | while read line; do
        echo \"Copying '$line' to /hugo/static/css\"
        cp -- \"$line\" hugo/static/css/application.css
      done"
    sh 'rm -rf ./public/assets'
  end
end
