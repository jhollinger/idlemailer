class InlineMailer
  include IdleMailer::Mailer

  def initialize(address, message)
    @message = message
    mail.to = address
    mail.subject = 'Foo Bar'
  end

  text %(
An inline text message: <%= @message %>
  )

  html %(
<p>An inline html message: <%= @message %></p>
  )
end
