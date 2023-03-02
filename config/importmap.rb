# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "intl-tel-input", to: "https://ga.jspm.io/npm:intl-tel-input@17.0.19/index.js"
pin_all_from "app/javascript/controllers", under: "controllers"
