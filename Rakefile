require 'bundler'
Bundler.setup :default, :test

desc "Run tests"
task :test do
  ARGV.shift
  files = if ARGV.any?
    ARGV.inject([]) do |a, arg|
      if File.file? arg
        a << "./#{arg}"
      elsif File.directory? arg
        a += Dir.glob("./#{arg}/**/*_test.rb")
      else
        a
      end
    end
  else
    Dir.glob('./test/**/*_test.rb')
  end
  files.each &method(:require)
end
