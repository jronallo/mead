module Mead
  class Identifier

    attr_accessor :mead, :eadid, :series, :container, :folder, :sequence, :page, 
      :ead_location, :metadata
    include Mead::Validations
    validates_format_of_mead
    validates_presence_of_mead
    validates_numericality_of_mead :sequence, :page

    # If a location is given then extraction can take place
    def initialize(mead, ead_location=nil)
      @mead = mead
      @metadata = nil
      parse_mead 'eadid', 'series', 'container', 'folder', 'sequence'
      @ead_location = parse_ead_location(ead_location)
      split_container
      split_folder
      split_page
      clean_zeros 'series', 'sequence', 'page'      
      self
    end

    def parse_mead(*args)
      parts = @mead.split('-')
      args.each_with_index do |field, i|
        instance_variable_set('@' + field, parts[i])
      end    
    end

    def split_container
      type = CONTAINER_MAPPING[ @container[0,2] ]
      number = strip_zeros(@container[2,10].gsub('_','.'))
      @container = {:type=> type, :number=> number}
    end
    
    def split_folder
      if CONTAINER_MAPPING.keys.include?(@folder[0,2])
        type = CONTAINER_MAPPING[ @folder[0,2] ] 
        number = strip_zeros(@folder[2,10].gsub('_','.').gsub('~', '-').gsub(/^0*/,''))
      else
        type = 'folder'
        number = strip_zeros(@folder.gsub('_','.').gsub('~', '-').gsub(/^0*/,''))
      end
      if number.nil? or (number and number.empty?)
        @folder = nil
      else
        @folder = {:type=> type, :number=> number}
      end
      
    end

    def clean_zeros(*args)
      args.each do |field|
        instance_var = instance_variable_get('@' + field)
        if instance_var
          cleaned_value = strip_zeros(instance_var)
          instance_variable_set('@' + field, cleaned_value)
        end
      end
    end

    def strip_zeros(num)
      num.sub(/^0+/,'')
    end
    
    def split_page
      @sequence, @page = sequence.split('_')
    end
    
    def parse_ead_location(loc)
      return nil if loc.nil?
      if loc
        if loc.is_a? File 
          loc.rewind if loc.eof?
          @ead_location = loc
        elsif loc.include?('http://')
          if loc.include?(@eadid)
            @ead_location = loc
          else
            @ead_location = File.join(loc, @eadid + '.xml')
          end
        end
      end
    end
    
    def extract
      @metadata = Mead::Extractor.new(self).extract
      self
    end
    
#    def ead_has_series?
#      if series > 1
#        true
#      else
#        if 
#        false
#      end
#    end

#    def replace_underscores(*args)
#      args.each do |field|
#        value = instance_variable_get('@' + field).gsub('_', '.')
#        instance_variable_set('@' + field, value)
#      end
#    end

  end
end
