require 'test_helper'

class TestingTest < Minitest::Test
  include IdleMailer::Testing::Helpers

  def setup
    FooMailer.new('user1@example.com', 'Foo', 'AAA').deliver
    FooMailer.new('user2@example.com', 'Bar', 'BBB').deliver
  end

  def teardown
    Mail::TestMailer.deliveries.clear
  end

  def test_records_sent_mail
    assert_equal 2, sent_mail.size
  end

  def test_clears_mail
    clear_mail!
    assert_equal 0, sent_mail.size
  end

  def test_sent_mail_from
    assert sent_mail_from? 'test@example.com'
    refute sent_mail_from? 'wrong@example.com'
  end

  def test_sent_mail_to
    assert sent_mail_to? 'user1@example.com'
    assert sent_mail_to? 'user2@example.com'
    refute sent_mail_to? 'user3@example.com'

    assert sent_mail_to? 'user1@example.com', /Foo/
    refute sent_mail_to? 'user1@example.com', /Bar/

    assert sent_mail_to? 'user1@example.com', /Foo/, /AAA/
    refute sent_mail_to? 'user1@example.com', /Foo/, /BBB/
  end

  def test_sent_mail_with_subject
    assert sent_mail_with_subject?(/Foo/)
    assert sent_mail_with_subject?(/Bar/)
    refute sent_mail_with_subject?(/Nope/)
  end

  def test_sent_mail_with_body
    assert sent_mail_with_body?(/AAA/)
    assert sent_mail_with_body?(/BBB/)
    refute sent_mail_with_body?(/Nope/)
  end

  def test_mail_from
    assert_equal 2, mail_from('test@example.com').size
    assert_equal 0, mail_from('wrong@example.com').size
  end

  def test_mail_to
    assert_equal 1, mail_to('user1@example.com').size
    assert_equal 1, mail_to('user2@example.com').size
    assert_equal 0, mail_to('user3@example.com').size

    assert_equal 1, mail_to('user1@example.com', /Foo/).size
    assert_equal 0, mail_to('user1@example.com', /Bar/).size

    assert_equal 1, mail_to('user1@example.com', /Foo/, /AAA/).size
    assert_equal 0, mail_to('user1@example.com', /Foo/, /BBB/).size
  end

  def test_mail_with_subject
    assert_equal 1, mail_with_subject(/Foo/).size
    assert_equal 1, mail_with_subject(/Bar/).size
    assert_equal 0, mail_with_subject(/Nope/).size
  end

  def test_mail_with_body
    assert_equal 1, mail_with_body(/AAA/).size
    assert_equal 1, mail_with_body(/BBB/).size
    assert_equal 0, mail_with_body(/Nope/).size
  end
end
