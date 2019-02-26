# rails new temp1 -d postgresql --skip-coffee --skip-turbolinks
# rails new temp1 -d postgresql --skip-coffee --skip-turbolinks --webpack -m kevin-template.rb

require "fileutils"
require "shellwords"

RAILS_REQUIREMENT = ">= 5.2.2".freeze

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-jumpstart-"))
    puts "source_paths = #{source_paths.inspect}"
    # at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/web-ascender/rails-jumpstart.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-jumpstart/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def default_gemfile_gem_version(name)
  @original_gemfile ||= IO.read("Gemfile")
  req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,[><~= \t\d\.\w'"]*)?.*$/, 1]
  req && req.gsub("'", %(")).strip.sub(/^,\s*"/, ', "')
end

def assert_minimum_rails_version
  puts "** TEMPLATE ** #{__method__}"
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

def assert_postgresql
  puts "** TEMPLATE ** #{__method__}"
  return if IO.read("Gemfile") =~ /^\s*gem ['"]pg['"]/
  fail Rails::Generators::Error,
       "This template requires PostgreSQL, "\
       "but the pg gem isn’t present in your Gemfile."
end

def set_application_name
  puts "** TEMPLATE ** #{__method__}"
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.parent_name"

  # Announce where to change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end

# def stop_spring
#   run "spring stop"
# end

def setup_webpack
  puts "** TEMPLATE ** #{__method__}"
  # rename app/javascript to app/webpacker
  inside "app" do
    run 'mv javascript webpacker'
  end
  directory "app/webpacker", force: true
  # change webpacker source path
  gsub_file 'config/webpacker.yml', /source_path: app\/javascript/, 'source_path: app/webpacker'
  copy_file 'app/assets/javascripts/cable.js', 'app/webpacker/cable.js'
  remove_dir 'app/assets/javascripts'
  remove_dir 'app/assets/stylesheets'
end

def copy_app_templates
  puts "** TEMPLATE ** #{__method__}"
  # https://github.com/excid3/jumpstart/blob/master/template.rb
  directory "app/views", force: true
  directory "app/controllers", force: true
  # directory "config", force: true
  # directory "lib", force: true

  # https://github.com/damienlethiec/modern-rails-template
  # template "Gemfile.tt", force: true
  # template 'README.md.tt', force: true
  # apply 'config/template.rb'
  # apply 'app/template.rb'
  # copy_file 'Procfile'
  # copy_file 'Procfile.dev'
end

def setup_bootstrap
  puts "** TEMPLATE ** #{__method__}"
  # Bootstrap v4 requires jQuery and the Popper.js lib
  # jquery-ujs   Rails jQuery helpers
  # jquery-ui    Useful for date pickers
  run 'yarn add bootstrap jquery popper.js jquery-ujs jquery-ui'

  insert_into_file 'config/webpack/environment.js', "const webpack = require('webpack')\n", after: "const { environment } = require('@rails/webpacker')\n"

  # Provide plugin auto-imports libraries
  insert_into_file 'config/webpack/environment.js', before: "module.exports = environment" do
    <<-JS
environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    jquery: "jquery",
    Popper: ["popper.js", "default"]
  })
)

    JS
  end

  # add jQuery package path to webpacker resolved_paths config
  gsub_file 'config/webpacker.yml', /resolved_paths: \[\]/, "resolved_paths: ['node_modules/jquery/dist']"

  setup_expose_loader
end

def setup_expose_loader
  puts "** TEMPLATE ** #{__method__}"
  run 'yarn add expose-loader'
  # expose-loader adds libraries to the window object (global scope)
  # this is useful for things like jQuery because many 3rd-party libs expect it as a global
  insert_into_file 'config/webpack/environment.js', before: "module.exports = environment" do
    <<-JS
environment.loaders.append("expose", {
  test: require.resolve('jquery'),
  use: [{
    loader: 'expose-loader',
    options: 'jQuery'
  }, {
    loader: 'expose-loader',
    options: '$'
  }]
})

    JS
  end
end

def setup_devise_with_user_models
  puts "** TEMPLATE ** #{__method__}"
  # Install Devise
  generate "devise:install"

  # ActionMailer config for development environment
  insert_into_file 'config/environments/development.rb', before: /^end/ do
    <<-RUBY

  # ActionMailer config
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end

 # Create Devise User Model
  generate :devise, "User",
           "first_name",
           "last_name",
           "superuser:boolean"

  # Set 'superuser' default to false in user migration
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:superuser/, ":superuser, default: false"
  end

  # insert_into_file 'app/models/user.rb', "\n  validates :first_name, :last_name, presence: true\n", before: /^end/

  # Generate Devise Bootstrap Views
  # https://github.com/hisea/devise-bootstrap-views
  run 'spring stop'
  generate "devise:views:bootstrap_templates"
end

# def setup_name_of_person
#   puts "** TEMPLATE ** #{__method__}"
#   # https://github.com/basecamp/name_of_person
#   insert_into_file 'app/models/user.rb', "  has_person_name\n", after: "class User < ApplicationRecord\n"
# end

def setup_simple_form
  puts "** TEMPLATE ** #{__method__}"
  run 'spring stop'
  generate "simple_form:install --bootstrap"

  # tweak the generate simple_form_bootstrap.rb config
  # remove the individual field-level 'is-valid' CSS classes, to de-clutter
  gsub_file "config/initializers/simple_form_bootstrap.rb", /config.input_field_valid_class = 'is-valid'/, "config.input_field_valid_class = ''"
  gsub_file "config/initializers/simple_form_bootstrap.rb", /(\w*\.use\s:input.*),\svalid_class:\s'is-valid'/, "\\1"
end

def setup_local_time
  puts "** TEMPLATE ** #{__method__}"
  run 'yarn add local-time'
end

def setup_cocoon
  puts "** TEMPLATE ** #{__method__}"

  # Cocoon is stubborn, it requires jQuery AND the asset pipeline
  # so we have to do some gymnastics here with webpacker to load it
  # via an ERB JS loader so that the asset paths are pulled in correctly
  run 'yarn add rails-erb-loader'
  directory "config/webpack/loaders", force: true
  insert_into_file 'config/webpack/environment.js', after: "const { environment } = require('@rails/webpacker')\n" do
    <<-JS
const erb =  require('./loaders/erb')
environment.loaders.append('erb', erb)
    JS
  end
  insert_into_file 'config/webpacker.yml', "    - .erb\n", after: "extensions:\n"
end

def setup_select2
  puts "** TEMPLATE ** #{__method__}"

  # select2 and a Bootstrap v4 theme
  run 'yarn add select2 @ttskch/select2-bootstrap4-theme'
end

def setup_sidekiq
  puts "** TEMPLATE ** #{__method__}"
  insert_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do
    <<-RUBY

  require 'sidekiq/web'
  mount Sidekiq::Web => '/admin/sidekiq'
    RUBY
  end

  run 'bundle binstubs sidekiq'
end

def setup_annotate
  puts "** TEMPLATE ** #{__method__}"
  run 'spring stop'
  generate 'annotate:install'

  # adjust annotate config
  # change annotation position from 'before' to 'after'
  gsub_file 'lib/tasks/auto_annotate_models.rake', /(?<==> ')(before)(?=')/, 'after'
  gsub_file 'lib/tasks/auto_annotate_models.rake', /'routes'\s*=>\s*'false'/, "'routes' => 'true'"

  run 'bundle binstubs annotate'
end

def setup_whenever
  puts "** TEMPLATE ** #{__method__}"
  run "wheneverize ."
end

def setup_bullet
  puts "** TEMPLATE ** #{__method__}"
  insert_into_file 'config/environments/development.rb', before: /^end/ do
    <<-RUBY

  # Bullet Config
  Bullet.enable = true
  Bullet.console = true
  Bullet.rails_logger = true
  Bullet.bullet_logger = true
  Bullet.rollbar = false
    RUBY
  end
end

def setup_routes
  puts "** TEMPLATE ** #{__method__}"
  route "root to: 'home#index'"

  insert_into_file 'config/routes.rb', after: "devise_for :users" do
    <<-RUBY

  scope '/user' do
    get '/profile', to: 'user_profile#edit', as: 'user_profile'
    patch '/profile', to: 'user_profile#update', as: 'user_update_profile'
  end

  get '/home', to: 'home#index'
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
    RUBY
  end
end

def setup_procfile
  puts "** TEMPLATE ** #{__method__}"
  template "foreman.tt", ".foreman"
  template "Procfile.dev.tt"
end

def fix_bundler_binstub
  # https://github.com/rails/rails/issues/31193
  run 'bundle binstubs bundler --force'
end

def convert_erb_to_haml
  puts "** TEMPLATE ** #{__method__}"
  run 'HAML_RAILS_DELETE_ERB=true HAML_RAILS_OVERWRITE_HAML=false rails haml:erb2haml'
end

def apply_template!
  puts '*'*100
  puts '  WEB ASCENDER RAILS JUMPSTART TEMPLATE'
  puts '*'*100

  # spring causes issues with our template, just disable it
  ENV["DISABLE_SPRING"] = "1"

  assert_minimum_rails_version
  assert_postgresql
  add_template_repository_to_source_path

  puts "** TEMPLATE ** copy [ Gemfile, ruby-version ]"
  template "Gemfile.tt", force: true
  template "ruby-version.tt", ".ruby-version", force: true

  # ask_optional_options
  # install_optional_gems

  after_bundle do
    set_application_name
    run "spring stop"
    setup_webpack
    copy_app_templates
    setup_bootstrap
    setup_devise_with_user_models
    # setup_name_of_person
    setup_simple_form
    setup_local_time
    setup_cocoon
    setup_select2
    setup_sidekiq
    setup_annotate
    setup_whenever
    setup_bullet
    setup_routes
    setup_procfile
    fix_bundler_binstub

    convert_erb_to_haml

    # DB create and migrate
    rails_command "db:create"
    rails_command "db:migrate"

    # git :init
    # git add: "."
    # git commit: %Q{ -m 'Initial commit' }

    puts "\n#{'*'*100}"
    puts "  TEMPLATED COMPLETED !\n"
    puts "  start your app with foreman:"
    puts "  $ foreman start"
    puts "*"*100
  end
end

run 'pgrep spring | xargs kill -9'
apply_template!