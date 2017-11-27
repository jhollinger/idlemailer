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
    # 'mail' is just a Mail object from the mail gem, so you can use the
    # full Mail api here, e.g. to, subject, attachments, etc.
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

Put the mailer into testing mode:

```ruby
IdleMailer.config do |config|
  config.delivery_method = :test
end
```

Then configure your test runner. Here's an example with RSpec:

```ruby
RSpec.configure do |config|
  # Clear sent mail after every test
  config.after :each do
    IdleMailer::Testing.clear_mail!
  end

  # Include the test helpers in your specs
  config.include IdleMailer::Testing::Helpers
end
```

Your tests will have access to these helper methods. (Note you can also call them directly on `IdleMailer::Testing` as well)

```ruby
# quick boolean checks
sent_mail_to? 'user@example.com'
sent_mail_to? 'user@example.com', /subject/
sent_mail_to? 'user@example.com', /subject/, /body/
sent_mail_with_subject? /Foo/
sent_mail_with_body? /Bar/
sent_mail_from? 'user@example.com'

# get arrays of matching sent mail (Mail::Message objects)
mail_to 'user@example.com'
mail_to 'user@example.com', /subject/
mail_to 'user@example.com', /subject/, /body/
mail_with_subject /Foo/
mail_with_body /Bar/
mail_from 'user@example.com'

# get an array of all sent mail
sent_mail

# clear all sent mail
clear_mail!
```

## License

MIT License. See LICENSE for details.

## Copyright

Copyright (c) 2015 Jordan Hollinger
