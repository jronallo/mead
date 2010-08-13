require 'helper'

class TestEadValidator < Test::Unit::TestCase
  
  context 'Given a directory of EAD XML validate them all' do
    setup do
      @eadv = Mead::EadValidator.new('test/ead/')
    end
    should 'store the directory path' do
      assert_equal 'test/ead/', @eadv.directory
    end
    should 'return results' do
      expected = {:valid=>["ua023_006"], :invalid=>["mc00240", "ua015_010", "ua023_031", "ua110_041"]}
      assert_equal expected, @eadv.validate!
    end
  end
end
