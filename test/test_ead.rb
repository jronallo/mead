require 'helper'

class TestMead < Test::Unit::TestCase
  context "Given an eadid mc00240" do

    setup do
      opts = {:eadid => 'mc00240', :file => File.open('test/ead/mc00240.xml')}
      @ead = Mead::Ead.new(opts) 
      @containers = @ead.containers
    end

    should "create information for a stub record for the first container" do
      expected = {:mead => 'mc00240-001-ff0181-000-001',
        :title => 'Adams, J. H. - Barn, 1929 (1075)',
        :series => 1
      }
      assert_equal expected, @containers[0]
    end

    should "create information for a stub record for the last container" do
      expected = {:mead => 'mc00240-003-bx0069-000-001',
        :title => 'Personnel Ledger, Pt. 2, 1956',
        :series => 3
      }
      assert_equal expected, @containers.last
    end
    
    should "determine this to be an invalid ead not suitable for large scale digitization yet" do
      assert_equal false, @ead.valid?
    end
    should "provide information on the containers with invalid (duplicate) mead identifiers" do
      assert_equal 47, @ead.invalid.length
      assert_equal 20, @ead.dups.length
      expected = {:series=>1, :title=>"Breach, William- Residence", :mead=>"mc00240-001-ff0298-000-001"}
      assert_equal expected, @ead.invalid.first
    end

    context "converted to csv" do
      setup do
        @csv = @ead.to_csv
        @csv_lines = @csv.split("\n")
      end
      should "be able to create a csv file from the parsed ead" do        
        assert_equal 'mead,title,series', @csv_lines[0]
      end

      should "be able to create good csv data from the parsed ead for the first container" do
        expected = 'mc00240-001-ff0181-000-001,"Adams, J. H. - Barn, 1929 (1075)",1'
        assert_equal expected, @csv_lines[1]
      end

      should "be able to create good csv data from the parsed ead for the last container" do
        expected = 'mc00240-003-bx0069-000-001,"Personnel Ledger, Pt. 2, 1956",3'
        assert_equal expected, @csv_lines.last
      end
    end    

  end

  context "Given an eadid of ua023_031" do
    setup do
      opts = {:eadid => 'ua023_031',:file => File.open('test/ead/ua023_031.xml')}
      @ead = Mead::Ead.new(opts)
      @containers = @ead.containers
    end
    should 'create information for a stub record for the first container' do
      expected = {:title=>"Sules V-B on Apple [3] - Grape Study - Set #17",
        :series=>1,
        :mead=>"ua023_031-001-cb0006-031-001"}
      assert_equal expected, @containers[0]
    end

    should 'create information for a stub record for the second container' do
      expected = {:mead=>"ua023_031-001-cb0010-010-001",
        :title=>
          "(no. 13) Eastern Carolina, North Carolina - Diec - cabbage and treated - Hand Colored Slides, Numbered Series",
        :series=>1}
      assert_equal expected, @containers[1]
    end

    should 'create information for a stub record for the last container' do
      expected = {:mead => 'ua023_031-010-cb0019-006-001',
        :title => 'Examples of original storage envelopes',
        :series => 10
      }
      assert_equal expected, @containers.last
    end
    
  end
  
  context "Given an eadid of mc00310" do
    setup do
      opts = {:eadid => 'mc00310', :url => 'http://www.lib.ncsu.edu/findingaids/mc00310.xml'}
      @ead = Mead::Ead.new( opts)
      @containers = @ead.containers
    end  
    should 'determine it to be a valid ead for large scale digitization' do
      assert @ead.valid?
    end
  end

  context "Given a baseurl and no filehandle for an Ead" do
    setup do
      opts = {:eadid => 'ua023_031', :baseurl => 'http://www.lib.ncsu.edu/findingaids'}
      @ead = Mead::Ead.new(opts)
    end
    should 'save the baseurl as an instance variable' do
      assert_equal 'http://www.lib.ncsu.edu/findingaids', @ead.baseurl
    end
    should 'create information for a stub record for the last container' do
      containers = @ead.containers
      expected = {:title=>"Sules V-B on Apple [3] - Grape Study - Set #17", :series=>1, :mead=>"ua023_031-001-cb0006-031-001"}
      assert_equal expected, containers.first
    end
  end
  
  context "Given a url and no file or baseurl for an Ead" do
    setup do
      opts = {:eadid => 'ua023_031', :url => 'http://www.lib.ncsu.edu/findingaids/ua023_031.xml'}
      @ead = Mead::Ead.new(opts)
    end
    should 'save the url to an instance variable' do
      assert_equal 'http://www.lib.ncsu.edu/findingaids/ua023_031.xml', @ead.url
    end
    should 'create information for a stub record for the last container' do
      containers = @ead.containers
      expected = {:title=>"Sules V-B on Apple [3] - Grape Study - Set #17", :series=>1, :mead=>"ua023_031-001-cb0006-031-001"}
      assert_equal expected, containers.first
    end
  end
  
  context "Given a baseurl and no eadid" do
    should 'raise an exception' do
      opts = {:baseurl => 'http://www.lib.ncsu.edu/findingaids'}
      assert_raise RuntimeError do
        Mead::Ead.new(opts)
      end
    end
  end


  context 'missing an eadid' do
    setup do      
      @expected = {:title=>"Sules V-B on Apple [3] - Grape Study - Set #17",
        :series=>1,
        :mead=>"ua023_031-001-cb0006-031-001"}    
    end
    context 'Given a file' do
      setup do
        opts = {:file => File.open('test/ead/ua023_031.xml')}
        @ead = Mead::Ead.new(opts)
      end
      should 'try to find the eadid in the EAD XML' do
        assert_equal 'ua023_031', @ead.eadid
      end
      should 'get information for the first container' do
        assert_equal @expected, @ead.containers.first
      end
    end
    
    context 'Given a full URL' do
      setup do
        opts = {:url => 'http://www.lib.ncsu.edu/findingaids/ua023_031.xml'}
        @ead = Mead::Ead.new(opts)
      end
      should 'try to find the eadid in the EAD XML' do
        assert_equal 'ua023_031', @ead.eadid
      end
      should 'get information for the first container' do
        assert_equal @expected, @ead.containers.first
      end
    end
  end


end
