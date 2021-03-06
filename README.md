# Rails Jumpstart Template

Start your Rails app with some great defaults and gems out of the box.

## Getting Started

Jumpstart is a Rails template, so you pass it in as an option when creating a new app.

### Requirements

You'll need the following installed to run the template successfully:

* **Ruby 2.6+**  (`rbenv` recommended [Install rbenv](https://github.com/rbenv/rbenv))
* **bundler**  (`gem install bundler`)
* **Rails 6.0.0** (`gem install rails`)
* **Node.js** LTS (`nvm` recommended [Install nvm](https://github.com/creationix/nvm))
* **Yarn** (`brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install))
* **PostgreSQL** (`Postgres.app` recommended on OSX https://postgresapp.com)

### Recommended

These are optional and nice to have, but the template will work without them:

* [foreman](https://github.com/ddollar/foreman) (`gem install foreman`)
  * **DO NOT ADD TO GEMFILE**
* [terminal-notifier](https://github.com/julienXX/terminal-notifier) (`gem install terminal-notifier`)
  * **DO NOT ADD TO GEMFILE**

## Installation (optional)

To make this the **default** Rails application template on your system, create a `~/.railsrc` file with these contents:

```
-d postgresql --skip-coffee --skip-turbolinks -m https://raw.githubusercontent.com/web-ascender/rails-jumpstart/master/template.rb
```

## Usage

To generate a Rails application using this template, pass the options below to `rails new`, like this:

```
$ rails new myapp -d postgresql --skip-coffee --skip-turbolinks -m https://raw.githubusercontent.com/web-ascender/rails-jumpstart/master/template.rb
```

Remember that **options must go after the name of the application** ("myapp" in this case). The only database supported by this template is PostgreSQL.

If you’ve installed this template as your default (using `~/.railsrc` as described above), then all you have to do is run:

```
$ rails new myapp
```

## What is included?

Below is a summary of what this template does. You can check all the features by following the code in `template.rb`

* `webpack` ([webpacker](https://github.com/rails/webpacker)) to serve all JS and CSS
  * renames the default `app/javascript` folder to `app/webpacker`
  * configures default pack in `app/webpacker/packs/application.js`
  * sprockets (asset pipeline) is left intact to serve images only
* [haml / hamlit](https://github.com/mfung/hamlit-rails) for view templates
* [bootstrap](https://getbootstrap.com/docs/4.0/getting-started/introduction/) (v4) UI framework
  * including jQuery and Popper.js dependencies
* `$`, `jQuery`, and `jquery` provided as window globals by default (for 3rd party compatibility)
  * Provide plugin and expose-loader
* [devise](https://github.com/plataformatec/devise) for authentication
  * generated devise bootstrap-themed views for user login, signup, forgot password, etc
  * `User` model with additional first_name and last_name attributes
* [Font Awesome 5](https://fontawesome.com/) SVG icons
  * **Required one-time setup for PRO:** https://fontawesome.com/how-to-use/on-the-web/setup/using-package-managers#installing-pro
  * auto-detects if you have the **PRO** npm auth key configured, fallback to FontAwesome **Free** icons if PRO not detected
* [sidekiq](https://sidekiq.org/) for background jobs
  * Web UI mounted at `/admin/sidekiq` by default
* [whenever](https://github.com/javan/whenever) for cron scheduling
* [jb](https://github.com/amatsuda/jb) simple and fast JSON views (jbuilder replacement)
* [httprb](https://github.com/httprb/http) a fast Ruby HTTP client with a chainable API, streaming support, and more

### Helpers

* [simple_form](https://github.com/plataformatec/simple_form) form helpers (with Bootstrap v4 theme)
* [cocoon](https://github.com/nathanvda/cocoon) form helpers for dynamic nested forms
* [local_time](https://github.com/basecamp/local_time) for easy formatting of user-facing timestamps
* [active_link_to](https://github.com/comfy/active_link_to) link helpers

### JavaScript Libraries

* jQuery, jQuery UI
* [jQuery UI DatePicker](https://jqueryui.com/datepicker/) configured out-of-the-box
  * also a custom `date_input` simple_form input helper
* [select2](https://select2.org/) dropdown library (with Bootstrap v4 theme)
* [axios](https://www.npmjs.com/package/axios) Promise based HTTP client for AJAX requests

### Content / Layout

* Nice starter layout based on Bootstrap 4
* Top Shared Navbar
* User menu in upper-right (login, my account, my profile, logout)
* Bottom sticky footer
* Nice rails `flash` messages shown at the bottom of the screen (and auto-hide after a few seconds)

### Development

* [dotenv-rails](https://github.com/bkeepers/dotenv) for loading ENV vars in development
* [annotate](https://github.com/ctran/annotate_models) for model/route documentation
* [bullet](https://github.com/flyerhzm/bullet) for N+1 detection
* [better_errors](https://github.com/BetterErrors/better_errors) for nicer error pages in development
* [awesome_print](https://github.com/awesome-print/awesome_print) for nicer console output in development
* [meta_request](https://github.com/dejan/rails_panel) support for [RailsPanel](https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg) chrome extension
* `.foreman` and `Procfile.dev` files to use `foreman start` in development

### OPTIONAL (user prompts during execution)

* Devise [OmniAuth Google OAuth2](https://github.com/zquestz/omniauth-google-oauth2) ([more info](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview))
  * Allows login via Google (in addition to normal devise database users)

## How does it work?

This project works by hooking into the standard Rails application templates system, with some caveats. The entry point is the `template.rb` file in the root of this repository.

Rails generators are very lightly documented; what you’ll find is that most of the heavy lifting is done by [Thor](https://github.com/erikhuda/thor). The most common methods used by this template are Thor’s `directory`, `copy_file`, `template`, `run`, `insert_into_file`, and `gsub_file`.

## Inspiration

* Chris Oliver https://github.com/excid3/jumpstart
* https://github.com/damienlethiec/modern-rails-template
* https://github.com/mattbrictson/rails-template
* https://github.com/shioyama/rails-template

## Authors

* [Kevin Southworth](https://github.com/ksouthworth)
