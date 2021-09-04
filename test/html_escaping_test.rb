require 'test_helper'

class HtmlEscapeTest < Minitest::Test
  def teardown
    Mail::TestMailer.deliveries.clear
  end

  def test_escape_template
    EscapeMailer.cache_templates!
    EscapeMailer.new('user@example.com', 'Foo', '<em>AAA</em>').deliver
    msg = Mail::TestMailer.deliveries.first.to_s
    assert_match(/<p>Escaped: &lt;em&gt;AAA&lt;\/em&gt;<\/p>/, msg)
    assert_match(/<p>Unescaped: <em>AAA<\/em><\/p>/, msg)
  end

  def test_escape_inline
    EscapeInlineMailer.new('user@example.com', 'Foo', '<em>AAA</em>').deliver
    msg = Mail::TestMailer.deliveries.first.to_s
    assert_match(/<p>Escaped: &lt;em&gt;AAA&lt;\/em&gt;<\/p>/, msg)
    assert_match(/<p>Unescaped: <em>AAA<\/em><\/p>/, msg)
  end
end
