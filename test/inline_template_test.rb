require 'test_helper'

class InlineTemplateTest < Minitest::Test
  def teardown
    Mail::TestMailer.deliveries.clear
  end

  def test_text_template
    InlineMailer.new('user@example.com', 'Secret message!').deliver
    assert_match /An inline text message: Secret message!/i, Mail::TestMailer.deliveries.first.to_s
  end

  def test_html_template
    InlineMailer.new('user@example.com', 'Secret message!').deliver
    assert_match /<p>An inline html message: Secret message!<\/p>/i, Mail::TestMailer.deliveries.first.to_s
  end
end
