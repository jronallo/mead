require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'
require 'fakeweb'
#require 'test_benchmark' # ruby 1.8.7 only?
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mead'

# disallow connections and then register all URIs used
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, 'http://www.lib.ncsu.edu/findingaids/ua023_031.xml',
  :response => File.join('test', 'fixtures', 'ua023_031.xml'))
FakeWeb.register_uri(:get, 'http://www.lib.ncsu.edu/findingaids/mc00310.xml',
  :response => File.join('test', 'fixtures', 'mc00310.xml'))

class Test::Unit::TestCase
end

# test cases should use stricter NCSU specific format validation
module Mead
  class Identifier
    def self.format_regexp
      container_codes = Mead::CONTAINER_MAPPING.keys.join('|')
      /^(ua\d{3}|mc\d{5})(_\d{3})?-\d{3}-(#{container_codes})\d{4}-\d{3}([A-Z])?-\d{3}(_\d{4})?$/
    end
  end
end

