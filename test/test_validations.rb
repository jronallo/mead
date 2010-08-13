require 'helper'

class TestMeadValidations < Test::Unit::TestCase
  require 'pp'
  def inspect_validation(mead)
    pp mead
    mead.valid?
    pp mead.errors
  end

  context "validating meads" do  
    setup do
      @loc_ua023_031 = File.open('test/ead/ua023_031.xml')
      @loc_mc00240 = File.open('test/ead/mc00240.xml')
    end  

    should "show ua023_031-001-cb0003-005-001 to be a valid mead" do
      mead = Mead::Identifier.new('ua023_031-001-cb0003-005-001', @loc_ua023_031)
      assert mead.valid?
    end

    should "show ua023_031-001-cb0013-019A-001 to be a valid mead" do
      mead = Mead::Identifier.new('ua023_031-001-cb0013-019A-001', @loc_ua023_031)
      assert mead.valid?
    end
    
    should "show ua023_031-001-cb0013-019A-001_0002 to be a valid mead" do
      mead = Mead::Identifier.new('ua023_031-001-cb0013-019A-001', @loc_ua023_031)
      assert mead.valid?
    end

    should "show ua023-031-01-cb003-05-01 to not be a well-formed mead" do
      mead = Mead::Identifier.new('ua023-031-01-cb003-05-01', @loc_ua023_031)
      assert_equal false, mead.valid?
    end

    should "show ua023_031-002-cb0006-031-001 to be well-formed but invalid because of series" do
      mead = Mead::Identifier.new('ua023_031-002-cb0006-031-001', @loc_ua023_031)
      assert_equal false, mead.valid?
    end
    
    should "show ua023_031-002-cb0006-031-001 to be well-formed" do
      mead = Mead::Identifier.new('ua023_031-002-cb0006-031-001', @loc_ua023_031)
      assert mead.valid_format?
    end

    should "show ua023_031-001-cb0156-031-001 to be well-formed but invalid" do
      mead = Mead::Identifier.new('ua023_031-002-cb0126-031-001', @loc_ua023_031)      
      assert_equal false, mead.valid?
    end

    # should a blank "folder" here be 001 rather than 000?
    should "show mc00240-001-ff0052-000-001 to be a valid mead" do
      mead = Mead::Identifier.new('mc00240-001-ff0052-000-001', @loc_mc00240)
      assert mead.valid?
    end
    should "show mc00240-001-ff0052-000-001_0002 to be a valid mead with a page" do
      mead = Mead::Identifier.new('mc00240-001-ff0052-000-001_0002', @loc_mc00240)
      #inspect_validation(mead)
      assert mead.valid?
    end
    
    should "use the cached metadata in the Mead::Identifier instead of making a new extraction request" do
      mead = Mead::Identifier.new('mc00240-001-ff0052-000-001_0002', @loc_mc00240).extract
      assert mead.valid?
    end
    
    should "show mc00240-002-bx0061-fr77_23,1-001 to be a well-formed mead" do
      mead = Mead::Identifier.new('mc00240-002-bx0061-fr77,23_1-001', @loc_mc00240).extract
      assert mead.valid?
    end
    
    should 'show mc00240-003-bx0068-fr002-001 to be a valid mead' do
      mead = Mead::Identifier.new('mc00240-003-bx0068-fr002-001', @loc_mc00240).extract
      assert mead.valid?
    end

  end

end
