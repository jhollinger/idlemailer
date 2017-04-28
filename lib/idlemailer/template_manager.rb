module IdleMailer
  module TemplateManager
    def self.extended(klass)
      klass.class_eval do
        class << self
          attr_reader :layouts, :templates
        end
        @layouts, @templates = {}, {}
      end
      klass.cache_templates! if IdleMailer.config.cache_templates
    end

    def text(str)
      templates['text'] = ERB.new str
    end

    def html(str)
      templates['html'] = ERB.new str
    end

    def template(type)
      templates[type] || ERB.new(template_path(template_name, type).read)
    end

    def layout(type)
      layouts[type] || ERB.new(template_path(IdleMailer.config.layout, type).read)
    end

    def has_template?(type)
      templates.has_key?(type) || template_path(template_name, type).exist?
    end

    def has_layout?(type)
      layouts.has_key?(type) || template_path(IdleMailer.config.layout, type).exist?
    end

    def template_name
      @name ||= self.name.
        gsub(/::/, File::SEPARATOR).
        sub(/Mailer$/, '').
        gsub(/([a-z])([A-Z])/, "\\1_\\2").
        downcase
    end

    def template_path(name, type)
      IdleMailer.config.templates.join("#{name}.#{type}.erb")
    end

    def cache_templates!
      layouts['text'] = layout 'text' if has_layout? 'text'
      layouts['html'] = layout 'html' if has_layout? 'html'
      templates['text'] = template 'text' if has_template? 'text'
      templates['html'] = template 'html' if has_template? 'html'
    end
  end
end
