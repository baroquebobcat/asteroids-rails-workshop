require "net/http"
require "net/https"
require "uri"

TEMPLATE_ROOT = "https://raw.github.com/baroquebobcat/asteroids-rails-workshop/master"

# Downloads a file, swiching to a secure connection if the source requires it. Also creates parent directories if they do not exist.
# ==== Parameters
# * +source+ - The remote source URL.
# * +destination+ - The local file destination path.
def download_file source, destination
  say_status :download, "#{source} to #{destination}."
  uri = URI.parse source
  http = Net::HTTP.new uri.host, uri.port
  http.use_ssl = uri.scheme == "https"
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new uri.request_uri
  response = http.request request
  project_file = File.join destination_root, destination
  project_directory = File.dirname project_file
  FileUtils.mkdir_p(project_directory) unless File.exist?(project_directory)
  File.open(project_file, "w") {|file| file.write response.body}
end

# Ruby Version Management (rbenv)
download_file "#{TEMPLATE_ROOT}/rails/rbenv-version.txt", ".rbenv-version"

# Configurations
download_file "#{TEMPLATE_ROOT}/rails/config/database.yml", "config/database.yml"
download_file "#{TEMPLATE_ROOT}/rails/config/initializers/system.rb", "config/initializers/system.rb"
insert_into_file "config/environments/development.rb", "\n  # Enables Guard::LiveReload support without requiring a browser extension.\n  config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload\n", after: "  # Settings specified here will take precedence over those in config/application.rb\n"
insert_into_file "config/environments/development.rb", "  config.action_mailer.smtp_settings = { :address => \"localhost\", :port => 1025 }\n", after: "  config.action_mailer.raise_delivery_errors = false\n"
insert_into_file "config/environments/development.rb", "  config.action_mailer.delivery_method = :smtp\n", after: "  config.action_mailer.raise_delivery_errors = false\n"
application_delta = "config/application.delta.rb"
download_file("#{TEMPLATE_ROOT}/rails/config/application.delta.rb", application_delta)
insert_into_file "config/application.rb", open(application_delta).read, after: "  config.assets.version = '1.0'\n"
gsub_file "config/application.rb", /# config.time_zone = \'Central Time \(US & Canada\)\'/, "config.time_zone = \"UTC\""
gsub_file "config/application.rb", /# config.i18n.default_locale = :de/, "config.i18n.default_locale = \"en\""
remove_file "#{application_delta}"

# Gems
download_file "#{TEMPLATE_ROOT}/rails/Gemfile", "Gemfile"
run "bundle install"
generate "simple_form:install --bootstrap"
generate "rspec:install"
download_file "#{TEMPLATE_ROOT}/rails/rspec.txt", ".rspec"
create_file "spec/factories.rb"
run "bundle exec guard init rspec"
run "bundle exec guard init livereload"

# Controllers
insert_into_file "app/controllers/application_controller.rb", "  helper :all\n", after: "class ApplicationController < ActionController::Base\n"
download_file "#{TEMPLATE_ROOT}/rails/app/controllers/home_controller.rb", "app/controllers/home_controller.rb"
download_file "#{TEMPLATE_ROOT}/rails/app/controllers/about_controller.rb", "app/controllers/about_controller.rb"

# Routes
route "resource :about, controller: \"about\""
route "resource :home, controller: \"home\""
route "root to: \"home#show\""

# Helpers
download_file "#{TEMPLATE_ROOT}/rails/app/helpers/navigation/menu.rb", "app/helpers/navigation/menu.rb"
download_file "#{TEMPLATE_ROOT}/rails/app/helpers/navigation/item.rb", "app/helpers/navigation/item.rb"
download_file "#{TEMPLATE_ROOT}/rails/app/helpers/layout_helper.rb", "app/helpers/layout_helper.rb"
download_file "#{TEMPLATE_ROOT}/rails/app/helpers/navigation_helper.rb", "app/helpers/navigation_helper.rb"
download_file "#{TEMPLATE_ROOT}/rails/app/helpers/visitor_helper.rb", "app/helpers/visitor_helper.rb"

# Views
remove_file "public/index.html"
download_file "#{TEMPLATE_ROOT}/rails/app/views/layouts/application.html.erb", "app/views/layouts/application.html.erb"
download_file "#{TEMPLATE_ROOT}/rails/app/views/shared/_flash_messages.html.erb", "app/views/shared/_flash_messages.html.erb"
download_file "#{TEMPLATE_ROOT}/rails/app/views/shared/_error_messages.html.erb", "app/views/shared/_error_messages.html.erb"
download_file "#{TEMPLATE_ROOT}/rails/app/views/home/show.html.erb", "app/views/home/show.html.erb"
download_file "#{TEMPLATE_ROOT}/rails/app/views/about/show.html.erb", "app/views/about/show.html.erb"

# Images
remove_file "app/assets/images/rails.png"
download_file "#{TEMPLATE_ROOT}/rails/public/apple-touch-icon-114x114.png", "public/apple-touch-icon-114x114.png"
download_file "#{TEMPLATE_ROOT}/rails/public/apple-touch-icon.png", "public/apple-touch-icon.png"
download_file "#{TEMPLATE_ROOT}/rails/public/favicon.ico", "public/favicon.ico"

# Stylesheets
remove_file "app/assets/stylesheets/application.css"
download_file "#{TEMPLATE_ROOT}/rails/app/assets/stylesheets/application.css.scss", "app/assets/stylesheets/application.css.scss"
download_file "#{TEMPLATE_ROOT}/rails/app/assets/stylesheets/bootstrap-patch.css.scss", "app/assets/stylesheets/bootstrap-patch.css.scss"
download_file "#{TEMPLATE_ROOT}/rails/app/assets/stylesheets/game.css.scss", "app/assets/stylesheets/game.css.scss"
download_file "#{TEMPLATE_ROOT}/rails/app/assets/stylesheets/shared.css.scss", "app/assets/stylesheets/shared.css.scss"

# JavaScripts
download_file "#{TEMPLATE_ROOT}/rails/app/assets/javascripts/application.js", "app/assets/javascripts/application.js"
download_file "#{TEMPLATE_ROOT}/rails/app/assets/javascripts/shared.js", "app/assets/javascripts/shared.js"
download_file "#{TEMPLATE_ROOT}/rails/vendor/assets/javascripts/game.js", "vendor/assets/javascripts/game.js"
download_file "#{TEMPLATE_ROOT}/rails/vendor/assets/javascripts/ipad.js", "vendor/assets/javascripts/ipad.js"
download_file "#{TEMPLATE_ROOT}/rails/vendor/assets/javascripts/vector_battle_regular.typeface.js", "vendor/assets/javascripts/vector_battle_regular.typeface.js"
download_file "http://code.jquery.com/jquery-1.4.1.js", "vendor/assets/javascripts/jquery.js"

# Doc
file "README.rdoc", "TODO - Document application."
file "doc/README_FOR_APP", "TODO - Document application."
download_file "#{TEMPLATE_ROOT}/rails/public/humans.txt", "public/humans.txt"

# Git
download_file "#{TEMPLATE_ROOT}/rails/gitignore.txt", ".gitignore"

# End
say_status :end, "MakeItHappen Setup Complete!"
