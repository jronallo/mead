require 'helper'

class TestMead < Test::Unit::TestCase
  context "Given an eadid mc00240" do

    setup do
      opts = {:file_handle => File.open('test/ead/mc00240.xml')}
      @ead = Mead::EAD.new('mc00240', opts) 
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
      opts = {:file_handle => File.open('test/ead/ua023_031.xml')}
      @ead = Mead::EAD.new('ua023_031', opts)
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

  context "Given a baseurl and no filehandle for an EAD" do
    setup do
      opts = {:baseurl => 'http://www.lib.ncsu.edu/findingaids'}
      @ead = Mead::EAD.new('ua023_031', opts)
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







end
