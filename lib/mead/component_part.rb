module Mead
  class ComponentPart
    attr_accessor :unittitle, :unitdate, :unitid, :level, 
      :series_sequence, :containers, 
      :item_location #FIXME: temporary attribute while refactoring
    
    def initialize(opts={})
      @item_location = opts[:item_location] if opts[:item_location]
      @unittitle = opts[:unittitle] if opts[:unittitle]
      @unitdate = opts[:unitdate] if opts[:unitdate]
      @unitid = opts[:unitid] if opts[:unitid]
      @level = opts[:level] if opts[:level]
      self.series_sequence = opts[:series_sequence] if opts[:series_sequence]
      
      
      if opts[:containers] 
        @containers = []
        # FIXME: What is a better way to insure the Array-ness of containers?
        if opts[:containers].is_a? Array
          opts[:containers].each do |container|
            if container.is_a?(Mead::Container)
              @containers << container
            else
              raise 'containers must have only Mead::Containers'
            end
          end
        else
          raise 'containers must be in an Array'
        end
      end
    end
    
    def series_sequence=(integer)
      if !integer.is_a?(Integer)
        # FIXME: create better error class
        raise RuntimeError, 'series_sequence must be an integer'
      end
      @series_sequence = integer
    end
    
#    def <<(container)
#      @containers << container
#    end

    # FIXME: must be a better way to implement my own equality. How to get all
    # the symbols for the possible attributes for an instance of a class?
    def ==(another_cp)
      return false if !another_cp.is_a?(Mead::ComponentPart)
      [:unittitle, :unitdate, :unitid, :level, 
      :series_sequence, :containers, 
      :item_location].each do |attribute|
        if self.send(attribute) != another_cp.send(attribute)
          return false
        end
      end
      return true
    end
    
    def containers=(container)
      @containers = []
      self.containers << container
    end
    
    # FIXME: temporary method while refactoring
    def [](attribute)
      self.send(attribute)
    end
    
    def to_json(*a)
     h = {
       'json_class'   => self.class.name
     }
     self.instance_variables.each do |var|
       h[var.sub('@','').to_sym] = self.send(var.sub('@','').to_sym)
     end
     h.to_json(*a)
   end
        
  end
end
