module IdleMailer
  # Renders templates and delivers message
  class Message
    # Mail object to deliver
    attr_reader :mail
    # The IdleMailer::Mailer object
    attr_reader :mailer

    # Initialize a new mailer 
    def initialize(mail, mailer)
      @mail = mail
      @mailer = mailer
    end

    # Deliver mail
    def deliver!
      log_to_stdout if IdleMailer.config.log
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
      mail.deliver!
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
      @name ||= mailer.class.name.sub(/Mailer$/, '').gsub(/([a-z])([A-Z])/, "\\1_\\2").downcase
    end

    def template_path(name, type)
      IdleMailer.config.templates.join("#{name}.#{type}.erb")
    end

    def log_to_stdout
      $stdout.puts [mail.to, mail.cc, mail.bcc].flatten.compact.join('; ')
      $stdout.puts mail.subject
      $stdout.puts(layout('html') { body('html') }) if has_template? 'html'
      $stdout.puts(layout('text') { body('text') }) if has_template? 'text'
    end
  end
end
