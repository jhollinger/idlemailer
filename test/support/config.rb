IdleMailer.config do |config|
  config.templates = Pathname.new(File.join(File.dirname(__FILE__), 'templates'))
  config.default_from = 'test@example.com'
  config.delivery_method = :test
end
