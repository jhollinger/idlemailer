$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'idlemailer'
require 'minitest/autorun'
Dir.glob('./test/support/*.rb').each { |file| require file }
