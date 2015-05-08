module IdleMailer
  # Struct for holding IdleMailer config
  #   templates A Pathname object pointing to the mail templates directory (defaults to ./templates)
  #   layout Name of layout file, minus extention (defaults to mailer_layout)
  #   delivery_method Symbol like :smtp or :test (see the mail gem for all options)
  #   delivery_options Hash of delivery options (see the mail gem for all options)
  #   default_from Default "from" address if it's left blank
  #   log When true, writes delivered messages to $stdout (default false)
  Config = Struct.new(:templates, :layout, :delivery_method, :delivery_options, :default_from, :log)
  @config = Config.new

  # Takes a block and hands it an IdleMailer::Config object
  def self.config
    if block_given?
      yield @config
      config = @config
      Mail.defaults do
        delivery_method config.delivery_method, config.delivery_options
      end
    end
    @config
  end
end
