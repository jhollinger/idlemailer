require 'test_helper'

class TemplateTest < Minitest::Test
  def setup
    FooMailer.templates.clear
    FooMailer.layouts.clear
  end

  def teardown
    Mail::TestMailer.deliveries.clear
  end

  def test_has_template
    assert WidgetMailer.has_template? 'html'
  end

  def test_doesnt_have_template
    refute WidgetMailer.has_template? 'json'
  end

  def test_has_layout
    assert WidgetMailer.has_layout? 'html'
  end

  def test_doesnt_have_layout
    refute WidgetMailer.has_layout? 'json'
  end

  def test_precache
    assert_nil FooMailer.templates['text']
    assert_nil FooMailer.templates['html']
    assert_nil FooMailer.layouts['text']
    assert_nil FooMailer.layouts['html']
    FooMailer.cache_templates!
    refute_nil FooMailer.templates['text']
    refute_nil FooMailer.templates['html']
    refute_nil FooMailer.layouts['text']
    refute_nil FooMailer.layouts['html']
  end

  def test_templates_but_not_results_are_cached
    FooMailer.cache_templates!
    FooMailer.new('user@example.com', 'Foo', 'AAA').deliver
    assert_match(/AAA/, Mail::TestMailer.deliveries.first.to_s)

    Mail::TestMailer.deliveries.clear
    FooMailer.new('user@example.com', 'Foo', 'BBB').deliver
    refute_match(/AAA/, Mail::TestMailer.deliveries.first.to_s)
    assert_match(/BBB/, Mail::TestMailer.deliveries.first.to_s)
  end

  def test_namespaced_mailer_template_name
    mailer = MyNamespace::V1::Mailers::UsersMailer
    assert_equal mailer.template_name, 'my_namespace/v1/mailers/users'
  end
end
