require 'tmpdir'
require 'logger'
require 'test_helper'

class LoggingTest < Minitest::Test
  def setup
    @widget = Widget.new('Foo', 1234)
    @log_file = File.join(Dir.tmpdir, 'delivery_log.log')
  end

  def teardown
    IdleMailer.config do |config|
      config.logger = nil
      config.log_body = false
    end
    File.unlink @log_file if File.exists? @log_file
    Mail::TestMailer.deliveries.clear
  end

  def test_log_to_file
    IdleMailer.config do |config|
      config.logger = Logger.new @log_file
      config.log_body = false
    end
    WidgetMailer.new('user@example.com', @widget).deliver
    assert File.exists?(@log_file)
    assert_match /New Widget/, File.read(@log_file)
    refute_match /template for widget/, File.read(@log_file)
  end

  def test_log_body_to_file
    IdleMailer.config do |config|
      config.logger = Logger.new @log_file
      config.log_body = true
    end
    WidgetMailer.new('user@example.com', @widget).deliver
    assert File.exists?(@log_file)
    assert_match /New Widget/, File.read(@log_file)
    assert_match /template for widget/, File.read(@log_file)
  end
end
