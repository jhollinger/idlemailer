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
      if has_template? 'html'
        html_body = layout('html') { body('html') }
        mail.html_part do
          content_type 'text/html; charset=UTF-8'
          body html_body
        end
      end
      if has_template? 'text'
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
      render template_path(template_name, type)
    end

    def layout(type)
      has_layout?(type) ? render(template_path(IdleMailer.config.layout, type)) { yield } : yield
    end

    def render(path)
      mailer.render(ERB.new(File.read(path))) { yield }
    end

    def has_template?(type)
      File.exists? template_path(template_name, type)
    end

    def has_layout?(type)
      File.exists? template_path(IdleMailer.config.layout, type)
    end

    def template_name
      @name ||= mailer.class.name.
        gsub(/::/, File::SEPARATOR).
        sub(/Mailer$/, '').
        gsub(/([a-z])([A-Z])/, "\\1_\\2").
        downcase
    end

    def template_path(name, type)
      IdleMailer.config.templates.join("#{name}.#{type}.erb")
    end
  end
end
