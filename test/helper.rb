require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mead'

class Test::Unit::TestCase
end

module Mead
  class Identifier
    def self.format_regexp
      container_codes = Mead::CONTAINER_MAPPING.keys.join('|') 
      /^(ua\d{3}|mc\d{5})(_\d{3})?-\d{3}-(#{container_codes})\d{4}-\d{3}([A-Z])?-\d{3}(_\d{4})?$/
    end 
  end
end
