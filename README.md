# Rails Jumpstart Template

Start your Rails app with some great defaults and gem out of the box.

## Getting Started

Jumpstart is a Rails template, so you pass it in as an option when creating a new app.

### Requirements

You'll need the following installed to run the template successfully:

* **Ruby 2.5+**  (`rbenv` recommended [Install rbenv](https://github.com/rbenv/rbenv))
* **bundler**  (`gem install bundler`)
* **Rails 5.2.x** (`gem install rails`)
* **Node.js** LTS (`nvm` recommended [Install nvm](https://github.com/creationix/nvm))
* **Yarn** (`brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install))
* **PostgreSQL** (`Postgres.app` recommended on OSX https://postgresapp.com)

## Installation

*Optional*

To make this the default Rails application template on your system, create a ~/.railsrc file with these contents:

```
-d postgresql --skip-coffee --skip-turbolinks -m https://github.com/web-ascender/rails-jumpstart/master/template.rb
```

## Usage

To generate a Rails application using this template, pass the options below to `rails new`, like this:

```
$ rails new myapp -d postgresql --skip-coffee --skip-turbolinks -m https://github.com/web-ascender/rails-jumpstart/master/template.rb
```

Remember that **options must go after the name of the application** ("myapp" in this case). The only database supported by this template is PostgreSQL.

If you’ve installed this template as your default (using ~/.railsrc as described above), then all you have to do is run:

```
$ rails new myapp
```

## What is included?

Below is an extract of what this generator does. You can check all the features by following the code in `template.rb`

* `webpack` / `webpacker` to serve all JS and CSS
  * renames the default `app/javascript` folder to `app/webpacker`
  * configures default pack in `app/webpacker/packs/application.js`
  * sprockets (asset pipeline) is left intact to serve images
* `haml` for view templates
* `boostrap` (v4) UI framework
  * including jQuery and Popper.js dependencies
* `$`, `jQuery`, and `jquery` provided as window globals by default
  * Provide plugin and expose-loader
* `simple_form` rails form helpers
* `devise` for authentication with a default `User` model
  * first_name and last_name fields
* `cocoon` form helpers for client-side add/remove associations
* `sidekiq` for background jobs
  * Web UI mounted at `/admin/sidekiq` by default
* `local_time` for easy formatting of user-facing timestamps
* `select2` dropdown library (with Bootstrap v4 theme)
* `active_link_to` link helpers
* `whenever` gem for cron scheduling
* `jb` gem (jbuilder replacement for simpler and faster JSON views)
* `name_of_person` helper methods for person names
* `sassc-rails` for faster SASS compilation

### Content / Layout

* Nice starter layout based on Bootstrap 4
* Top Shared Navbar
* User menu in upper-right (login, my account, my profile, logout)
* Bottom sticky footer
* Nice rails "flash" messages shown at the bottom of the screen (and auto-hide after a few seconds)

### Development

* `dotenv-rails` for loading ENV vars in development
* `annotate` gem for model/route documentation
* `bullet` gem for N+1 detection
* `better_errors` for nicer error pages in development
* `awesome_print` for nicer console output in development
* `meta_request` support for `RailsPanel` chrome extension
* `Procfile.dev` for using `foreman start` in development


## How does it work?

This project works by hooking into the standard Rails application templates system, with some caveats. The entry point is the template.rb file in the root of this repository.

Rails generators are very lightly documented; what you’ll find is that most of the heavy lifting is done by [Thor](https://github.com/erikhuda/thor). The most common methods used by this template are Thor’s `directory`, `copy_file`, `template`, `run`, `insert_into_file`, and `gsub_file`.

## Inspiration

* Chris Oliver https://github.com/excid3/jumpstart
* https://github.com/damienlethiec/modern-rails-template
* https://github.com/mattbrictson/rails-template
* https://github.com/shioyama/rails-template