class FooMailer
  include IdleMailer::Mailer

  def initialize(addr, msg)
    @msg = msg
    mail.to = addr
    mail.subject = 'Foo'
  end
end
