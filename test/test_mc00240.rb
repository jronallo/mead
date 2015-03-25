require 'helper'

class TestMeadMC00240 < Test::Unit::TestCase

  context "a legacy mead from mc00240" do
    setup do
      @mead_id = 'mc00240-001-ff0147-001-001_0001' #empty folder was given 001 rather than 000
      @fh = File.open('test/ead/mc00240.xml')
      @mead = Mead::Identifier.new(@mead_id, @fh)
    end
    should "retrieve the correct metadata" do
      @mead.extract
      expected = [Mead::ComponentPart.new({:unittitle=>"Moravian Chapel at Southside", :level=>"file",
                    :item_location=>"flatfolder 147", :unitdate=>"1928", :unitid=>"1034",
                      :containers =>
                      [Mead::Container.new(:localtype => 'flatfolder',
                                            :label => "Mixed materials",
                                            :text => '147')]
                    }),
                   Mead::ComponentPart.new({:unittitle=>"Drawings", :series_sequence=>1,
                    :level=>"series", :unitdate=>"1917-1980", :unitid=>"MC 240 Series 1"})]
      assert_equal expected, @mead.metadata
    end
  end


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
        expected = {:localtype=> 'flatfolder', :number => '42'}
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
        #@file = File.open('test/ead/mc00240.xml')
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

        should "Cache the metadata in the Mead::Identifier" do
          mead = Mead::Identifier.new(@mead_id, @fh).extract
          assert_equal @result, mead.metadata
        end

        should "extract the item's unittitle" do
          assert_equal 'Amos Hosiery Mill - Addition', @extractor.stack[0][:unittitle]
        end

        should "extract the item's unitdate" do
          assert_equal '1953', @extractor.stack[0][:unitdate]
        end

        should "extract the item's level" do
          assert_equal 'file', @extractor.stack[0][:level]
        end

        should "extract the item's unitid" do
          assert_equal '1421', @extractor.stack[0][:unitid]
        end

        should "extract the item's containers" do
          assert_equal @extractor.stack[0][:containers].first.class, Mead::Container
        end

        should "extract the parent unittitle" do
          assert_equal "Drawings", @extractor.stack[1][:unittitle]
        end

        should "extract the parent unitdate" do
          assert_equal "1917-1980", @extractor.stack[1][:unitdate]
        end

        should "extract the parent level" do
          assert_equal "series", @extractor.stack[1][:level]
        end

        should "extract the parent unitid" do
          assert_equal 'MC 240 Series 1', @extractor.stack[1][:unitid]
        end

        should "extract a series' series number" do
          assert_equal 1, @extractor.stack[1][:series_sequence]
        end



      end

    end



  end

end
