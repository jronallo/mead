require 'helper'

class TestMeadUA015_010 < Test::Unit::TestCase

  context "a mead from ua015_010" do
    setup do
      @mead = 'ua015_010-004-bx0039-005-002'     
    end

    context "parsing a mead from ua015_010" do
      setup do
        @result = Mead::Identifier.new(@mead, File.open('test/ead/ua015_010.xml')) #this is where processing
      end

      should "produce expected output of eadid" do
        assert_equal @result.eadid, 'ua015_010'
      end

      should "produce the expected series" do
        assert_equal @result.series, '4'
      end

      should "produce the expected container" do
        expected = {:type=> 'box', :number => '39'}
        assert_equal expected, @result.container
      end

      should "produce the expected folder" do
        assert_equal @result.folder, {:type=> 'folder', :number => '5'}
      end

      should "produce the expected sequence" do
        assert_equal @result.sequence, '2'
      end
    end

    context "extracting metadata from a mead" do
      setup do
        @result = Mead::Identifier.new(@mead, File.open('test/ead/ua015_010.xml'))
        @extractor = Mead::Extractor.new(@result)        
      end

      should "be able to create an extractor" do
        assert_equal @extractor.class, Mead::Extractor
      end

      should "convert a string to a mead object" do
        assert_equal @extractor.mead.class, Mead::Identifier
      end

      context "should give back the metadata" do
        setup do          
          @result = @extractor.extract
        end

        should "extract the item's unittitle" do
          assert_equal 'Programs', @extractor.stack[0][:unittitle]
        end

        should "extract the item's unitdate" do
          assert_equal '1949-1950', @extractor.stack[0][:unitdate]
        end
        
        should "extract the item level" do
          assert_equal 'file', @extractor.stack[0][:level]
        end
        
        should "extract the item unitid" do
          assert_nil @extractor.stack[0][:unitid]
        end

        should "extract the parent unittitle" do
          assert_equal "Men's Basketball", @extractor.stack[1][:unittitle]
        end

        should "extract the parent unitdate" do
          assert_equal "1911-2006", @extractor.stack[1][:unitdate]
        end
        
        should "extract the parent level" do
          assert_equal 'series', @extractor.stack[1][:level]
        end
        
        should "extract the parent unitid" do
          assert_equal 'Series 4', @extractor.stack[1][:unitid]
        end
        
        should "extract a series' series number" do
          assert_equal 4, @extractor.stack[1][:series_sequence]
        end



      end

    end

    

  end
  
end
