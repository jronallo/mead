require 'helper'

class TestComponentPart < Test::Unit::TestCase
  
  should "create a new component part with no options" do
    assert Mead::ComponentPart.new 
  end
  
  context "creating a component part with good options" do
    should "have a unittitle attribute" do
      cp = Mead::ComponentPart.new(:unittitle => 'unit title')
      assert_equal 'unit title', cp.unittitle
    end
    
    should "have a unitdate attribute" do
      cp = Mead::ComponentPart.new(:unitdate => 'unit date')
      assert_equal 'unit date', cp.unitdate
    end
    
    should 'have a unitid attribute' do
      cp = Mead::ComponentPart.new(:unitid => 'unit id')
      assert_equal 'unit id', cp.unitid
    end
    
    should 'have a level attribute' do
      cp = Mead::ComponentPart.new(:level => 'level')
      assert_equal 'level', cp.level
    end
    
    should 'have a series_sequence attribute' do
      cp = Mead::ComponentPart.new(:series_sequence => 8)
      assert_equal 8, cp.series_sequence
    end
    
    should 'not allow a non-Integer as the series_sequence' do
      assert_raise(RuntimeError){ Mead::ComponentPart.new(:series_sequence => '8')}
    end
    
    should 'allow for assinging containers as an option' do
      container1 = Mead::Container.new(:level => 'file')
      container2 = Mead::Container.new(:level => 'series')
      cp = Mead::ComponentPart.new(:containers => [container1, container2])
      assert_equal [container1, container2], cp.containers
    end
    
    should 'raise if trying to mass assign non-Array to containers' do
      assert_raise(RuntimeError){ Mead::ComponentPart.new(:containers => 'asdfa')}      
    end
    
    should 'raise if trying to mass assign non-Containers to containers' do
      assert_raise(RuntimeError){Mead::ComponentPart.new(:containers => ['asdfa'])}
    end
    
    should 'not automatically create an empty array for containers' do
      cp = Mead::ComponentPart.new
      assert_nil cp.containers
    end
    
  end
  
  context "build up component part values" do
    setup do
      @cp = Mead::ComponentPart.new
    end
    
    should 'allow a unittitle to be assigned' do
      @cp.unittitle = 'unit title'
      assert_equal 'unit title', @cp.unittitle
    end
    
    should 'allow a unitdate to be assigned' do
      @cp.unitdate = 'unit date'
      assert_equal 'unit date', @cp.unitdate
    end
    
    should 'allow a unitid to be assigned' do
      @cp.unitid = 'unit id'
      assert_equal 'unit id', @cp.unitid
    end
    
    should 'allow a level to be assigned' do
      @cp.level = 'level'
      assert_equal 'level', @cp.level
    end
    
    should 'allow a series_sequence to be assigned' do
      @cp.series_sequence = 8
      assert_equal 8, @cp.series_sequence
    end
    
    should 'not allow a string to be assigned to the series_sequence' do
      assert_raise(RuntimeError) {@cp.series_sequence = '9'}
    end
    
    should 'store containers as an array' do
      @cp.containers = [Mead::Container.new]
      assert @cp.containers.is_a? Array
    end
    
    should 'allow for adding to the containers array' #do
#      container = Mead::Container.new
#      @cp.containers << container
#      assert_equal [container], @cp.containers
#    end
    
    should 'not allow for adding a non-Container to containers' #do
#      assert_raise(RuntimeError){@cp.containers << 'asdf'}
#    end
    
    context 'multiple containers' do
      setup do
        @container1 = Mead::Container.new(:type => 'file')
        @container2 = Mead::Container.new(:type => 'series')
      end      
      
      should 'allow assigning directly to containers, but resetting everything there' #do        
#        @cp.containers << @container1
#        assert_equal [@container1], @cp.containers
#        
#        @cp.containers = @container2
#        assert_equal [@container2], @cp.containers
#      end
      
      should 'add a container on to the end of the containers' #do
#        @cp.containers << @container1 
#        @cp.containers << @container2
#        assert_equal [@container1, @container2], @cp.containers
#      end
      
    end
    
  end
  
  
end
