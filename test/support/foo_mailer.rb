class FooMailer
  include IdleMailer::Mailer

  def initialize(addr, subject, msg)
    @msg = msg
    mail.to = addr
    mail.subject = subject
  end
end
