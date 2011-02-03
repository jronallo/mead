require 'helper'

class TestMeadUA021_428 < Test::Unit::TestCase
  context "extracting metadata from a mead" do
      setup do
        @mead = 'ua021_428-001-cb0007-000-001'
        @result = Mead::Identifier.new(@mead, File.open('test/ead/ua021_428.xml'))
        @extractor = Mead::Extractor.new(@result) 
        @extractor.extract       
      end
      
      should "have metadata" do
        assert !@extractor.stack.empty?
      end
      
      should 'show ua021_428-001-cb0007-000-001 to be a valid mead' do
        mead = Mead::Identifier.new(@mead, File.open('test/ead/ua021_428.xml')).extract
        assert mead.valid_format?
        assert mead.valid?
      end

      
    end
  
end

