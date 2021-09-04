class EscapeMailer
  include IdleMailer::Mailer

  def initialize(addr, subject, msg)
    @input = msg
    mail.to = addr
    mail.subject = subject
  end
end
