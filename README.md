# IdleMailer

A lightweight (~150 line) alternative to ActionMailer for Rubyists who are too cool for Rails. Powered by the [mail](http://www.rubydoc.info/gems/mail) gem. Great for API-only backends that need to send email.

## Installation

Add to your Gemfile.

    gem 'idlemailer'

## Use

IdleMailer provides mailer classes and templates on top of the [mail](http://www.rubydoc.info/gems/mail) gem. `mail` has a great API, so you have unfettered access to it in your mailers.

```ruby
# Define your mailer class
class WidgetMailer
  include IdleMailer::Mailer

  def initialize(user, widget)
    @widget = widget
    mail.to = user.email
    mail.subject = "Widget #{widget.sku}"
  end
end

# Create widget.html.erb and/or widget.text.erb in your templates directory.
# They'll have access to instance variables like @widget above.

# Send your mail
WidgetMailer.new(current_user, widget).deliver
```

### Inline templates

Instead of creating template files, you can embed your ERB templates right inside your Ruby class.

```ruby
class WidgetMailer
  include IdleMailer::Mailer

  def initialize(user, widget)
    @widget = widget
    mail.to = user.email
    mail.subject = "Widget #{widget.sku}"
  end

  text %(
A new widget called <%= @widget %> was just created!

Thanks!
  )

  html %(
<p>A new widget called <%= @widget %> was just created!</p>

<p>Thanks!</p>
  )
end
```

## Configure

These are the default options. Salt to taste.

```ruby
IdleMailer.config do |config|
  # Directory containing the mailer templates
  config.templates = Pathname.new(Dir.getwd).join('templates')

  # Pre-cache all templates and layouts (instead of re-loading them on each delivery)
  config.cache_templates = true

  # Name of the layout template. Here, the file(s) would be named
  # mailer_layout.html.erb and/or mailer_layout.text.erb.
  config.layout = 'mailer_layout'

  # Email delivery method (mail gem). Set to :test when testing or when developing locally
  config.delivery_method = :smtp

  # Delivery options (mail gem)
  config.delivery_options = {
    user_name: ENV['MAIL_USER'],
    password: ENV['MAIL_PASSWORD'],
    domain: ENV['MAIL_DOMAIN'],
    address: ENV['MAIL_ADDRESS'],
    port: ENV['MAIL_PORT'] || 587,
    authentication: ENV['MAIL_AUTHENTICATION'] || 'plain',
    enable_starttls_auto: (ENV['MAIL_TLS'] ? true : false)
  }

  # Default "from" address for all mailers
  config.default_from = nil

  # Log sent emails (require 'logger')
  # config.logger = Logger.new($stdout)
  # config.logger = Logger.new('log/mailers.log')
  config.logger = nil

  # Write full message body to log (if enabled). Otherwise, only message headers are logged.
  config.log_body = false
end
```

## Testing

Put the mailer in testing mode:

```ruby
IdleMailer.config do |config|
  config.delivery_method = :test
end
```

Then use mail gem's built in testing helpers in your specs:

```ruby
sent = Mail::TestMailer.deliveries.any? { |mail| mail.to.include? @user.email }
```

## License

MIT License. See LICENSE for details.

## Copyright

Copyright (c) 2015 Jordan Hollinger
