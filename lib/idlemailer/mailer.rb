module IdleMailer
  # Module to include in your mailer classes. Example:
  #
  #  class WidgetMailer
  #    include IdleMailer::Mailer
  #
  #    # optionally override the default layout
  #    self.layout = "widget_layout"
  #
  #    def initialize(address, widget)
  #      mail.to = address
  #      mail.subject = "Widget #{widget.sku}"
  #      # See mail gem docs for more options - http://www.rubydoc.info/gems/mail
  #      @widget = widget
  #    end
  #  end
  #
  #  # Name your templates "widget.html.erb" and "widget.text.erb". They'll have access to "@widget".
  #
  #  mailer = WidgetMailer.new(current_user.email, widget)
  #  mailer.deliver
  #
  module Mailer
    def self.included(klass)
      klass.extend TemplateManager
    end

    # Deliver mail
    def deliver
      mailer = IdleMailer::Message.new(mail, self)
      mailer.deliver!
    end

    # Render an ERB template with the mailer's binding
    def render(template)
      template.result(binding { yield })
    end

    private

    # Mail config object
    def mail
      @mail ||= Mail.new
    end
  end
end
