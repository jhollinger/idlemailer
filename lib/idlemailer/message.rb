module IdleMailer
  # Renders templates and delivers message
  class Message
    # Mail object to deliver
    attr_reader :mail
    # The IdleMailer::Mailer object
    attr_reader :mailer

    # Initialize a new message
    def initialize(mail, mailer)
      @mail, @mailer = mail, mailer
    end

    # Deliver mail
    def deliver!
      if mailer.class.has_template? 'html'
        html_body = layout('html') { body('html') }
        mail.html_part do
          content_type 'text/html; charset=UTF-8'
          body html_body
        end
      end

      if mailer.class.has_template? 'text'
        text_body = layout('text') { body('text') }
        mail.text_part { body text_body }
      end

      config = IdleMailer.config
      mail.from config.default_from if mail.from.nil?
      mail.delivery_method config.delivery_method, config.delivery_options
      message = mail.deliver
      config.logger.info(config.log_body ? message.to_s : message) if config.logger
      message
    end

    private

    def body(type)
      render mailer.class.template(type)
    end

    def layout(type)
      mailer.class.has_layout?(type) ? render(mailer.class.layout(type)) { yield } : yield
    end

    def render(template)
      mailer.render(template) { yield }
    end
  end
end
