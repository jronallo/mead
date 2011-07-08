require 'helper'

class TestMeadExtractor < Test::Unit::TestCase
  context "the mead ua023_031-008-cb0013-001-001" do
    setup do

      @identifier = 'ua023_031-008-cb0013-001-001'
      @expected_1 = [
       Mead::ComponentPart.new(
        {:level=>"file", 
        :unitdate=>nil, 
        :unitid=>nil, 
        :unittitle=>
            "Horticulture - students in greenhouse - for photograph see - Agriculture school - Horticulture - Hand Colored Slides, agriculture school",
        :item_location => 'cardbox 13, Envelope 1',
        :containers => [
          Mead::Container.new(:type => 'cardbox', :label => "Mixed materials", :text => '13'), 
          Mead::Container.new(:type => 'Envelope', :text => '1')]
        }),
        Mead::ComponentPart.new({:level=>"subseries", :unitdate=>nil, :unitid=>nil, :unittitle=>"Students"}),
        Mead::ComponentPart.new({:level=>"series", :unitdate=>nil, :series_sequence=>8, :unitid=>"Series 8", :unittitle=>"People"})]
    end

    should "produce a good extraction with a filehandle location for the Ead" do
      fh   = File.open('test/ead/ua023_031.xml')
      mead = Mead::Identifier.new(@identifier, fh)
      assert_equal @expected_1, Mead::Extractor.new(mead).extract
    end

    should "producde a good extraction with a remote location Ead containing no eadid" do
      assert_equal @expected_1, Mead::Extractor.new(Mead::Identifier.new(@identifier, 'http://www.lib.ncsu.edu/findingaids')).extract
    end
    should 'produce a good extraction with a remote location Ead with a full URL' do
      assert_equal @expected_1, Mead::Extractor.new(Mead::Identifier.new(@identifier, 'http://www.lib.ncsu.edu/findingaids/ua023_031.xml')).extract
    end


    context 'mc00240-001-ff0052-000-001' do
      setup do
        @expected_mc00240 = [Mead::ComponentPart.new({:unittitle=>"Friends Church",
                    :item_location=>"flatfolder 52",
                    :unitdate=>"1927",
                    :level=>"file",
                    :unitid=>"903",
                    :containers => 
                    [Mead::Container.new(:type => 'flatfolder', :label => 'Mixed materials', :text => '52')]}),
                   Mead::ComponentPart.new({:series_sequence=>1,
                    :unittitle=>"Drawings",
                    :unitdate=>"1917-1980",
                    :level=>"series",
                    :unitid=>"MC 240 Series 1"})]
      end
      should 'handle empty folder properly' do
        mead = Mead::Identifier.new('mc00240-001-ff0052-000-001', File.open('test/ead/mc00240.xml'))
        assert_equal @expected_mc00240, Mead::Extractor.new(mead).extract
      end

      should 'cache the extraction within the Mead::Identifier' do
        mead = Mead::Identifier.new('mc00240-001-ff0052-000-001', File.open('test/ead/mc00240.xml')).extract
        assert_equal @expected_mc00240, mead.metadata
      end
    end

  end

  should "raise an exception if the extractor is given something other than a Mead::Identifier" do
    assert_raise RuntimeError do
      Mead::Extractor.new({})
    end
  end
  should "raise an exception if the extractor tries to extract from a Mead::Identifier without an Ead location set" do
    assert_raise RuntimeError do
      Mead::Extractor.new(Mead::Identifier.new('mc00240-001-ff0052-000-001')).extract
    end
  end
  should "raise an exception when a duplicate Mead::Identifier is found by matching too many nodes" do
    assert_raise RuntimeError do
      Mead::Extractor.new(Mead::Identifier.new('mc00240-003-bx0069-000-001', File.open('test/ead/mc00240.xml'))).extract
    end
  end


end

