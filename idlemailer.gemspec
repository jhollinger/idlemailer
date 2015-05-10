require File.join(File.dirname(__FILE__), 'lib', 'idlemailer', 'version')

Gem::Specification.new do |spec|
  spec.name = 'idlemailer'
  spec.version = IdleMailer::VERSION
  spec.summary = "A lightweight alternative to ActionMailer"
  spec.description = "Provides non-Rails projects with a lightweight ActionMailer-like wrapper around the mail gem"
  spec.authors = ['Jordan Hollinger']
  spec.date = '2015-05-11'
  spec.email = 'jordan@jordanhollinger.com'
  spec.homepage = 'https://github.com/jhollinger/idlemailer'

  spec.require_paths = ['lib']
  spec.files = [Dir.glob('lib/**/*'), 'README.md', 'LICENSE'].flatten

  spec.add_dependency 'mail', '~> 2.0'
end
