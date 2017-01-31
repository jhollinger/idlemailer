module IdleMailer
  # Renders templates and delivers message
  class Message
    # Mail object to deliver
    attr_reader :mail
    # The IdleMailer::Mailer object
    attr_reader :mailer

    # Initialize a new message
    def initialize(mail, mailer)
      @mail = mail
      @mailer = mailer
    end

    # Deliver mail
    def deliver!
      @can_deliver = true

      mail.from IdleMailer.config.default_from if mail.from.nil?

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

      deliver_message!
    end

    private

    # Really delivery message
    def deliver_message!
      raise "This method must be called from inside `deliver!` method" unless @can_deliver

      mail.delivery_method IdleMailer.config.delivery_method, IdleMailer.config.delivery_options
      message = mail.deliver

      log_message_deliver(message.to_s)

      message
    end

    # log to STDOUT and/or custom log
    def log_message_deliver(message)
      log_to_stdout(message)
      log_to_file(message)
    end

    def log_to_stdout(message)
      $stdout.puts message if IdleMailer.config.log
    end

    def log_to_file(message)
      IdleMailer.config.logger.info message if IdleMailer.config.logger
    end

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
      base_class = mailer.class.name.split("::").join(File::SEPARATOR)

      @name ||= base_class.sub(/Mailer$/, '').gsub(/([a-z])([A-Z])/, "\\1_\\2").downcase
    end

    def template_path(name, type)
      IdleMailer.config.templates.join("#{name}.#{type}.erb")
    end
  end
end
