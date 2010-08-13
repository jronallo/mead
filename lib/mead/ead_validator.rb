module Mead
  class EadValidator
    attr_accessor :directory, :valid, :invalid, :invalid_full
    
    # Creates a new EadValidator when given the path to a directory as a String  
    def initialize(directory)
      @directory = directory
      @valid = []
      @invalid = []
      @invalid_full = []
    end
    
    def validate!
      files = Dir.glob(File.join(@directory, '*.xml')).sort
      files.map do |path|       
        eadid = File.basename(path, '.xml')
        begin
          ead = Mead::Ead.new({:file => File.open(path), :eadid => eadid})
        rescue => e
          record_invalid(eadid, ead, e)
          next
        end
        if ead.valid? 
          @valid << eadid 
        else
          record_invalid(eadid, ead)
        end
      end
      metadata
    end
    
    def record_invalid(eadid, ead, error=nil)
      @invalid << eadid
      @invalid_full << {:eadid => eadid, :error => error, :dups => ead.dups, :containers => ead.invalid}
    end
    
    def metadata
      {:valid => @valid, :invalid => @invalid}
    end
  end
end
