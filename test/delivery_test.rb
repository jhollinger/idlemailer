require_relative 'test_helper'

class DeliveryTest < Minitest::Test
  def setup
    @widget = Widget.new('Foo', 1234)
  end

  def teardown
    Mail::TestMailer.deliveries.clear
  end

  def test_delivery
    WidgetMailer.new('user@example.com', @widget).deliver
    assert_equal 1, Mail::TestMailer.deliveries.length
  end

  def test_recipient
    WidgetMailer.new('user@example.com', @widget).deliver
    assert_equal 'user@example.com', Mail::TestMailer.deliveries.first.to[0]
  end

  def test_subject
    WidgetMailer.new('user@example.com', @widget).deliver
    assert_equal 'New Widget', Mail::TestMailer.deliveries.first.subject
  end

  def test_text_template
    WidgetMailer.new('user@example.com', @widget).deliver
    assert_match /text template for widget #{@widget.sku}/i, Mail::TestMailer.deliveries.first.to_s
  end

  def test_html_template
    WidgetMailer.new('user@example.com', @widget).deliver
    assert_match /html template for widget #{@widget.sku}/i, Mail::TestMailer.deliveries.first.to_s
  end

  def test_html_layout
    WidgetMailer.new('user@example.com', @widget).deliver
    assert_match /test html layout/i, Mail::TestMailer.deliveries.first.to_s
  end

  def test_namespaced_mailer_template_name
    user = User.new('Rafael Fidelis', 'myemail@email.com')
    mail = MyNamespace::V1::Mailers::UsersMailer.new(user)

    assert_equal mail.mailer.send(:template_name), 'my_namespace/v1/mailers/users'
  end

  def test_namespaced_html_template
    user = User.new('Rafael Fidelis', 'myemail@email.com')
    mail = MyNamespace::V1::Mailers::UsersMailer.new(user).deliver

    assert_match /Welcome #{user.name} to IdleMailer/i, mail.to_s
  end

  def test_ensure_deliver_method_call
    message = IdleMailer::Message.new('test@mailer.com', nil)

    assert_raises RuntimeError do
      message.send(:deliver_message!)
    end
  end

  def test_log_to_file
    require 'logger'
    log_file = File.expand_path('support/delivery_log.log', File.dirname(__FILE__))

    IdleMailer.config do |config|
      config.logger = Logger.new(log_file)
    end

    WidgetMailer.new('user@example.com', @widget).deliver

    assert_equal true, File.exists?(log_file)
  end

end
