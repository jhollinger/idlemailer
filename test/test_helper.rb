require 'idlemailer'
require 'minitest/autorun'

IdleMailer.config do |config|
  config.templates = Pathname.new(File.join(File.dirname(__FILE__), 'support', 'templates'))
  config.cache_templates = false
  config.default_from = 'test@example.com'
  config.delivery_method = :test
end

Dir.glob('./test/support/*.rb').each { |file| require file }
