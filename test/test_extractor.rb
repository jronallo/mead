require 'helper'

class TestMeadExtractor < Test::Unit::TestCase
  context "the mead ua023_031-008-cb0013-001-001" do
    setup do
      @identifier = 'ua023_031-008-cb0013-001-001'
      @expected_1 = [{:level=>"file", :unitdate=>nil, :unitid=>nil, :unittitle=>
            "Horticulture - students in greenhouse - for photograph see - Agriculture school - Horticulture - Hand Colored Slides, agriculture school",
        :item_location => 'cardbox 13, Envelope 1'},
        {:level=>"subseries", :unitdate=>nil, :unitid=>nil, :unittitle=>"Students"},
        {:level=>"series", :unitdate=>nil, :series_number=>8, :unitid=>"Series 8", :unittitle=>"People"}]
    end
    should "produce a good extraction with a filehandle location for the EAD" do
      fh   = File.open('test/ead/ua023_031.xml')
      mead = Mead::Identifier.new(@identifier, fh)
      assert_equal @expected_1, Mead::Extractor.new(mead).extract
    end
    should "producde a good extraction with a remote location EAD containing no eadid" do
      assert_equal @expected_1, Mead::Extractor.new(Mead::Identifier.new(@identifier, 'http://www.lib.ncsu.edu/findingaids')).extract      
    end
    should 'produce a good extraction with a remote location EAD with a full URL' do
      assert_equal @expected_1, Mead::Extractor.new(Mead::Identifier.new(@identifier, 'http://www.lib.ncsu.edu/findingaids/ua023_031.xml')).extract      
    end
        
    should 'handle empty folder properly' do
      expected = [{:unittitle=>"Friends Church",
                  :item_location=>"flatfolder 52",
                  :unitdate=>"1927",
                  :level=>"file",
                  :unitid=>"903"},
                 {:series_number=>1,
                  :unittitle=>"Drawings",
                  :unitdate=>"1917-1980",
                  :level=>"series",
                  :unitid=>"MC 240 Series 1"}]
      mead = Mead::Identifier.new('mc00240-001-ff0052-000-001', File.open('test/ead/mc00240.xml'))
      assert_equal expected, Mead::Extractor.new(mead).extract   
    end
    

  end
  
  should "raise an exception if the extractor is given something other than a Mead::Identifier" do
    assert_raise RuntimeError do
      Mead::Extractor.new({})
    end
  end
  should "raise an exception if the extractor tries to extract from a Mead::Identifier without an EAD location set" do
    assert_raise RuntimeError do
      Mead::Extractor.new(Mead::Identifier.new('mc00240-001-ff0052-000-001')).extract
    end
  end
  
  
end
