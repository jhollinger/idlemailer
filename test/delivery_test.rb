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
end
