class EscapeInlineMailer
  include IdleMailer::Mailer

  def initialize(addr, subject, msg)
    @input = msg
    mail.to = addr
    mail.subject = subject
  end

  text %(
Escaped: <%= @input %>
Unescaped: <%= raw @input %>
  )

  html %(
<p>Escaped: <%= @input %></p>
<p>Unescaped: <%= raw @input %></p>
  )
end
