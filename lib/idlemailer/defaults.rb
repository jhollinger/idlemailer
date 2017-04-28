IdleMailer.config do |config|
  config.templates = Pathname.new(Dir.getwd).join('templates')
  config.layout = 'mailer_layout'
  config.cache_templates = true
  config.delivery_method = :smtp
  config.delivery_options = {
    user_name: ENV['MAIL_USER'],
    password: ENV['MAIL_PASSWORD'],
    domain: ENV['MAIL_DOMAIN'],
    address: ENV['MAIL_ADDRESS'],
    port: ENV['MAIL_PORT'] || 587,
    authentication: ENV['MAIL_AUTHENTICATION'] || 'plain',
    enable_starttls_auto: (ENV['MAIL_TLS'] ? true : false)
  }
  config.default_from = nil
  config.logger = nil
  config.log_body = false
end
