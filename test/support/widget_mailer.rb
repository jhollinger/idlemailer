class WidgetMailer
  include IdleMailer::Mailer

  def initialize(address, widget)
    mail.to = address
    mail.subject = 'New Widget'
    @widget = widget
  end
end
