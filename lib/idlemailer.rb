require 'erb'
require 'pathname'
require 'mail'

require 'idlemailer/config'
require 'idlemailer/defaults'
require 'idlemailer/message'
require 'idlemailer/mailer'
require 'idlemailer/template_manager'
require 'idlemailer/templates'
require 'idlemailer/html_safe_string'
require 'idlemailer/version'

module IdleMailer
  autoload :Testing, 'idlemailer/testing'
end
