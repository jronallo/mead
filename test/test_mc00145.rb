require 'helper'

class TestMc00145 < Test::Unit::TestCase
  context "the ead mc00145" do
    setup do
      opts = {:eadid => 'mc00145', :file => File.open('test/ead/mc00145.xml')}
      @ead = Mead::Ead.new(opts)
      @containers = @ead.containers
    end
    
    should "create short meads for component parts with more than 2 containers" do
      assert !@containers.empty?
    end
    
    should "create meads for EAD with no series" do
      assert_equal 'mc00145-001-te0001-000-001', @containers.last[:mead]
    end
  end
end
