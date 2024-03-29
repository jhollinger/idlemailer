module IdleMailer
  # Loads a mailer's templates and layouts
  module TemplateManager
    def self.extended(klass)
      klass.class_eval do
        include Templates::Helpers
        class << self
          attr_reader :layouts, :templates
        end
        @custom_layout, @layouts, @templates = nil, {}, {}
      end
      klass.cache_templates! if IdleMailer.config.cache_templates
    end

    def text(str)
      templates['text'] = Templates.compile str.chomp
    end

    def html(str)
      templates['html'] = Templates.compile str.chomp
    end

    def template(type)
      templates[type] || Templates.compile(template_path(template_name, type).read.chomp)
    end

    def layout(type)
      layouts[type] || Templates.compile(template_path(layout_name, type).read.chomp)
    end

    def layout=(new_name)
      @custom_layout = new_name
      layouts.clear
      cache_templates! if IdleMailer.config.cache_templates
    end

    def has_template?(type)
      templates.has_key?(type) || template_path(template_name, type).exist?
    end

    def has_layout?(type)
      layouts.has_key?(type) || template_path(layout_name, type).exist?
    end

    def template_name
      @name ||= self.name.
        gsub(/::/, File::SEPARATOR).
        sub(/Mailer$/, '').
        gsub(/([a-z])([A-Z])/, "\\1_\\2").
        downcase
    end

    def layout_name
      @custom_layout || IdleMailer.config.layout
    end

    def template_path(name, type)
      IdleMailer.config.templates.join("#{name}.#{type}.erb")
    end

    def cache_templates!
      layouts['text'] ||= layout 'text' if has_layout? 'text'
      layouts['html'] ||= layout 'html' if has_layout? 'html'
      templates['text'] ||= template 'text' if has_template? 'text'
      templates['html'] ||= template 'html' if has_template? 'html'
    end
  end
end
