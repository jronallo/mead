require 'helper'

class TestMeadUA110_041 < Test::Unit::TestCase

  context "a mead from ua110_041" do
    setup do
      @mead = 'ua110_041-001-fr0001_1-000-001'
    end

    context "parsing a mead from ua110_041" do
      setup do
        @result = Mead::Identifier.new(@mead, File.open('test/ead/ua110_041.xml')) #this is where processing
      end

      should "produce expected output of eadid" do
        assert_equal @result.eadid, 'ua110_041'
      end

      should "produce the expected series" do
        assert_equal @result.series, '1'
      end

      should "produce the expected container" do
        expected = {:type=> 'folder', :number => '1.1'}
        assert_equal expected, @result.container
      end

      should "produce the expected folder" do
        assert_nil @result.folder
      end

      should "produce the expected sequence" do
        assert_equal @result.sequence, '1'
      end
    end

    context "extracting metadata from a mead" do
      setup do
        @result = Mead::Identifier.new(@mead, File.open('test/ead/ua110_041.xml'))
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
          assert_equal 'North Carolina, Wake County, Raleigh: Dix Hill [Dorothea Dix Hospital] Drawings', @extractor.stack[0][:unittitle]
        end

        should "extract the item's unitdate" do
          assert_nil @extractor.stack[0][:unitdate]
        end
        
        should "extract the item unitid" do
          assert_nil @extractor.stack[0][:unitid]
        end
        
        should "extract the item level" do
          assert_equal 'file', @extractor.stack[0][:level]
        end

        should "extract the parent unittitle" do
          assert_equal "UA 110.041 Series 1: Projects", @extractor.stack[1][:unittitle]
        end

        should "extract the parent unitdate" do
          assert_equal "1951-1976", @extractor.stack[1][:unitdate]
        end
        
        should "extract the parent unitid" do
          assert_nil @extractor.stack[1][:unitid]
        end
        
        should "extract the parent level" do
          assert_equal 'series', @extractor.stack[1][:level]
        end
        
        should "extract a series' series number" do
          assert_equal 1, @extractor.stack[1][:series_sequence]
        end



      end

    end



  end

end
