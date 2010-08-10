require 'helper'

class TestMeadMC00240 < Test::Unit::TestCase

  context "a mead from mc00240" do
    setup do
      @mead_id = 'mc00240-001-ff0042-000-001'      
      @fh = File.open('test/ead/mc00240.xml')
      @mead    = Mead::Identifier.new(@mead_id, @fh)
    end

    context "parsing a mead from mc00240" do      

      should "produce expected output of eadid" do
        assert_equal @mead.eadid, 'mc00240'
      end

      should "produce the expected series" do
        assert_equal @mead.series, '1'
      end

      should "produce the expected container" do
        expected = {:type=> 'flatfolder', :number => '42'}
        assert_equal expected, @mead.container
      end

      should "produce the expected folder" do
        assert_equal @mead.folder, nil
      end

      should "produce the expected sequence" do
        assert_equal @mead.sequence, '1'
      end
    end

    context "extracting metadata from a mead" do
      setup do
        @extractor = Mead::Extractor.new(@mead)
        @file = File.open('test/ead/mc00240.xml')
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
          assert_equal 'Amos Hosiery Mill - Addition', @extractor.stack[0][:unittitle]
        end

        should "extract the item's unitdate" do
          assert_equal '1953', @extractor.stack[0][:unitdate]
        end

        should "extract the parent unittitle" do
          assert_equal "Drawings", @extractor.stack[1][:unittitle]
        end

        should "extract the parent unitdate" do
          assert_equal "1917-1980", @extractor.stack[1][:unitdate]
        end

        should "only extract up to the series level" do
          assert_equal [
            {:unittitle=>"Amos Hosiery Mill - Addition", :unitdate=>"1953",
            :level => 'file', :unitid => '1421', :item_location => 'flatfolder 42'},
            {:unittitle=>"Drawings", :unitdate=>"1917-1980", :level => 'series',
              :unitid => 'MC 240 Series 1', :series_number => 1
            }
          ], @extractor.stack
        end

      end

    end



  end

end
